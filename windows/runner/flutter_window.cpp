#include "flutter_window.h"

#include <optional>
#include <windows.h>
#include <winuser.h>

#include "flutter/generated_plugin_registrant.h"
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/encodable_value.h>

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

// Global variables for kiosk mode
static HHOOK g_keyboard_hook = nullptr;
static bool g_kiosk_mode_enabled = false;
static HWND g_main_window = nullptr;

// Low-level keyboard hook to block system shortcuts
LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam) {
  if (nCode >= 0 && g_kiosk_mode_enabled) {
    KBDLLHOOKSTRUCT* pkbhs = (KBDLLHOOKSTRUCT*)lParam;
    
    // Block Alt+Tab, Alt+Esc, Ctrl+Esc, Win key, Alt+F4
    if (pkbhs->vkCode == VK_TAB && (GetAsyncKeyState(VK_MENU) & 0x8000)) {
      return 1; // Block Alt+Tab
    }
    if (pkbhs->vkCode == VK_ESCAPE && (GetAsyncKeyState(VK_MENU) & 0x8000)) {
      return 1; // Block Alt+Esc
    }
    if (pkbhs->vkCode == VK_ESCAPE && (GetAsyncKeyState(VK_CONTROL) & 0x8000)) {
      return 1; // Block Ctrl+Esc
    }
    if (pkbhs->vkCode == VK_LWIN || pkbhs->vkCode == VK_RWIN) {
      return 1; // Block Win key
    }
    if (pkbhs->vkCode == VK_F4 && (GetAsyncKeyState(VK_MENU) & 0x8000)) {
      return 1; // Block Alt+F4
    }
    // Block Task Manager (Ctrl+Shift+Esc)
    if (pkbhs->vkCode == VK_ESCAPE && 
        (GetAsyncKeyState(VK_CONTROL) & 0x8000) && 
        (GetAsyncKeyState(VK_SHIFT) & 0x8000)) {
      return 1;
    }
  }
  return CallNextHookEx(g_keyboard_hook, nCode, wParam, lParam);
}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Store main window handle
  g_main_window = GetHandle();

  // Set up platform channel for kiosk mode
  auto engine = flutter_controller_->engine();
  auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      engine->messenger(), "com.studex/kiosk",
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (call.method_name() == "enableKioskMode") {
          // Install keyboard hook
          if (g_keyboard_hook == nullptr) {
            g_keyboard_hook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc,
                                               GetModuleHandle(nullptr), 0);
          }
          g_kiosk_mode_enabled = true;
          
          // Make window always on top
          SetWindowPos(g_main_window, HWND_TOPMOST, 0, 0, 0, 0,
                      SWP_NOMOVE | SWP_NOSIZE);
          
          // Fullscreen
          LONG_PTR style = GetWindowLongPtr(g_main_window, GWL_STYLE);
          SetWindowLongPtr(g_main_window, GWL_STYLE, style & ~WS_OVERLAPPEDWINDOW);
          MONITORINFO mi = { sizeof(mi) };
          GetMonitorInfo(MonitorFromWindow(g_main_window, MONITOR_DEFAULTTONEAREST), &mi);
          SetWindowPos(g_main_window, nullptr, mi.rcMonitor.left, mi.rcMonitor.top,
                      mi.rcMonitor.right - mi.rcMonitor.left,
                      mi.rcMonitor.bottom - mi.rcMonitor.top,
                      SWP_NOZORDER | SWP_FRAMECHANGED);
          
          result->Success(flutter::EncodableValue(true));
        } else if (call.method_name() == "disableKioskMode") {
          // Remove keyboard hook
          if (g_keyboard_hook != nullptr) {
            UnhookWindowsHookEx(g_keyboard_hook);
            g_keyboard_hook = nullptr;
          }
          g_kiosk_mode_enabled = false;
          
          // Restore window
          SetWindowPos(g_main_window, HWND_NOTOPMOST, 0, 0, 0, 0,
                      SWP_NOMOVE | SWP_NOSIZE);
          
          LONG_PTR style = GetWindowLongPtr(g_main_window, GWL_STYLE);
          SetWindowLongPtr(g_main_window, GWL_STYLE, style | WS_OVERLAPPEDWINDOW);
          
          result->Success(flutter::EncodableValue(true));
        } else if (call.method_name() == "blockNotifications") {
          // Block notifications by setting focus mode (Windows 11) or do not disturb
          // This is a simplified implementation
          const auto* arguments = std::get_if<flutter::EncodableMap>(call.arguments());
          bool block = false;
          if (arguments) {
            auto block_it = arguments->find(flutter::EncodableValue("block"));
            if (block_it != arguments->end()) {
              block = std::get<bool>(block_it->second);
            }
          }
          // In a real implementation, you would use Windows APIs to block notifications
          result->Success(flutter::EncodableValue(true));
        } else {
          result->NotImplemented();
        }
      });

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  // Clean up keyboard hook
  if (g_keyboard_hook != nullptr) {
    UnhookWindowsHookEx(g_keyboard_hook);
    g_keyboard_hook = nullptr;
  }
  g_kiosk_mode_enabled = false;
  g_main_window = nullptr;

  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
    case WM_SYSCOMMAND:
      // Block system menu (Alt+Space) and minimize/maximize in kiosk mode
      if (g_kiosk_mode_enabled) {
        if (wparam == SC_MINIMIZE || wparam == SC_MAXIMIZE || 
            wparam == SC_RESTORE || wparam == SC_MOVE || 
            wparam == SC_SIZE || wparam == SC_CLOSE) {
          return 0; // Block these commands
        }
      }
      break;
    case WM_CLOSE:
      // Prevent window close in kiosk mode
      if (g_kiosk_mode_enabled) {
        return 0; // Block close
      }
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
