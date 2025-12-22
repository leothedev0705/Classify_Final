document.addEventListener('DOMContentLoaded', function() {
  // DOM Elements
  const homeScreen = document.getElementById('home-screen');
  const quizScreen = document.getElementById('quiz-screen');
  const resultsScreen = document.getElementById('results-screen');
  const subjectCards = document.querySelectorAll('.subject-card');
  const quizTitle = document.getElementById('quiz-title');
  const questionCounter = document.getElementById('question-counter');
  const questionText = document.getElementById('question-text');
  const optionsContainer = document.getElementById('options-container');
  const prevBtn = document.getElementById('prev-btn');
  const nextBtn = document.getElementById('next-btn');
  const submitBtn = document.getElementById('submit-btn');
  const scoreValue = document.getElementById('score-value');
  const scorePercentage = document.getElementById('score-percentage');
  const attemptsList = document.getElementById('attempts-list');
  const reviewBtn = document.getElementById('review-btn');
  const retryBtn = document.getElementById('retry-btn');
  const homeBtn = document.getElementById('home-btn');
  
  // Quiz variables
  let currentSubject = '';
  let currentQuestionIndex = 0;
  let userAnswers = [];
  let startTime;
  let timerInterval;
  let timerDisplay = document.getElementById('timer');
  
  // Initialize quiz data
  function initializeQuizData() {
    // Check if attempts history exists in localStorage
    if (!localStorage.getItem('quizAttempts')) {
      localStorage.setItem('quizAttempts', JSON.stringify({}));
    }
  }
  
  // Format time as mm:ss
  function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
  }
  
  // Update timer display
  function updateTimer() {
    const elapsedTime = Math.floor((Date.now() - startTime) / 1000);
    timerDisplay.textContent = `Time: ${formatTime(elapsedTime)}`;
    return elapsedTime;
  }
  
  // Start the quiz for a selected subject
  function startQuiz(subject) {
    currentSubject = subject;
    currentQuestionIndex = 0;
    userAnswers = Array(quizData[subject].questions.length).fill(null);
    
    // Set quiz title
    quizTitle.textContent = quizData[subject].title;
    
    // Show quiz screen
    homeScreen.classList.add('hidden');
    quizScreen.classList.remove('hidden');
    resultsScreen.classList.add('hidden');
    
    // Start timer
    startTime = Date.now();
    if (timerInterval) clearInterval(timerInterval);
    timerInterval = setInterval(updateTimer, 1000);
    
    // Display first question
    displayQuestion();
  }
  
  // Display the current question
  function displayQuestion() {
    const currentQuestion = quizData[currentSubject].questions[currentQuestionIndex];
    questionCounter.textContent = `Question ${currentQuestionIndex + 1}/${quizData[currentSubject].questions.length}`;
    questionText.textContent = currentQuestion.question;
    
    // Clear options and create new ones
    optionsContainer.innerHTML = '';
    currentQuestion.options.forEach((option, index) => {
      const optionItem = document.createElement('div');
      optionItem.className = 'option-item';
      if (userAnswers[currentQuestionIndex] === index) {
        optionItem.classList.add('selected');
      }
      optionItem.textContent = option;
      optionItem.setAttribute('data-index', index);
      optionItem.addEventListener('click', () => selectOption(index));
      optionsContainer.appendChild(optionItem);
    });
    
    // Update navigation buttons
    prevBtn.disabled = currentQuestionIndex === 0;
    nextBtn.disabled = currentQuestionIndex === quizData[currentSubject].questions.length - 1;
    
    // Show submit button on last question
    if (currentQuestionIndex === quizData[currentSubject].questions.length - 1) {
      submitBtn.classList.remove('hidden');
    } else {
      submitBtn.classList.add('hidden');
    }
  }
  
  // Handle option selection
  function selectOption(optionIndex) {
    userAnswers[currentQuestionIndex] = optionIndex;
    
    // Update selected option UI
    const options = optionsContainer.querySelectorAll('.option-item');
    options.forEach(option => {
      option.classList.remove('selected');
    });
    options[optionIndex].classList.add('selected');
  }
  
  // Go to the next question
  function nextQuestion() {
    if (currentQuestionIndex < quizData[currentSubject].questions.length - 1) {
      currentQuestionIndex++;
      displayQuestion();
    }
  }
  
  // Go to the previous question
  function prevQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      displayQuestion();
    }
  }
  
  // Calculate the score
  function calculateScore() {
    let score = 0;
    userAnswers.forEach((answer, index) => {
      if (answer === quizData[currentSubject].questions[index].correctAnswer) {
        score++;
      }
    });
    return score;
  }
  
  // Submit the quiz and show results
  function submitQuiz() {
    // Stop timer
    clearInterval(timerInterval);
    const timeTaken = updateTimer();
    
    // Calculate score
    const totalQuestions = quizData[currentSubject].questions.length;
    const score = calculateScore();
    const percentage = Math.round((score / totalQuestions) * 100);
    
    // Update results display
    scoreValue.textContent = `${score}/${totalQuestions}`;
    scorePercentage.textContent = `${percentage}%`;
    
    // Save attempt to localStorage
    saveAttempt(score, totalQuestions, timeTaken);
    
    // Display attempt history
    displayAttemptHistory();
    
    // Show results screen
    quizScreen.classList.add('hidden');
    resultsScreen.classList.remove('hidden');
  }
  
  // Save attempt to localStorage
  function saveAttempt(score, totalQuestions, timeTaken) {
    const attempts = JSON.parse(localStorage.getItem('quizAttempts'));
    
    if (!attempts[currentSubject]) {
      attempts[currentSubject] = [];
    }
    
    attempts[currentSubject].push({
      date: new Date().toLocaleString(),
      score: score,
      totalQuestions: totalQuestions,
      percentage: Math.round((score / totalQuestions) * 100),
      timeTaken: formatTime(timeTaken)
    });
    
    localStorage.setItem('quizAttempts', JSON.stringify(attempts));
  }
  
  // Display attempt history
  function displayAttemptHistory() {
    attemptsList.innerHTML = '';
    
    const attempts = JSON.parse(localStorage.getItem('quizAttempts'));
    
    if (!attempts[currentSubject] || attempts[currentSubject].length === 0) {
      const noAttempts = document.createElement('p');
      noAttempts.textContent = 'No previous attempts.';
      attemptsList.appendChild(noAttempts);
      return;
    }
    
    attempts[currentSubject].forEach((attempt, index) => {
      const attemptItem = document.createElement('div');
      attemptItem.className = 'attempt-item';
      
      const attemptInfo = document.createElement('div');
      attemptInfo.className = 'attempt-info';
      attemptInfo.innerHTML = `
        <p><strong>Attempt ${index + 1}</strong> - ${attempt.date}</p>
        <p>Time: ${attempt.timeTaken}</p>
      `;
      
      const attemptScore = document.createElement('div');
      attemptScore.className = 'attempt-score';
      attemptScore.innerHTML = `
        <p>${attempt.score}/${attempt.totalQuestions} (${attempt.percentage}%)</p>
      `;
      
      attemptItem.appendChild(attemptInfo);
      attemptItem.appendChild(attemptScore);
      attemptsList.appendChild(attemptItem);
    });
  }
  
  // Event listeners
  subjectCards.forEach(card => {
    card.addEventListener('click', () => {
      const subject = card.getAttribute('data-subject');
      startQuiz(subject);
    });
  });
  
  prevBtn.addEventListener('click', prevQuestion);
  nextBtn.addEventListener('click', nextQuestion);
  submitBtn.addEventListener('click', submitQuiz);
  
  retryBtn.addEventListener('click', () => {
    startQuiz(currentSubject);
  });
  
  homeBtn.addEventListener('click', () => {
    homeScreen.classList.remove('hidden');
    resultsScreen.classList.add('hidden');
    
    // Clear any running timer
    if (timerInterval) clearInterval(timerInterval);
  });
  
  // Initialize
  initializeQuizData();
}); 