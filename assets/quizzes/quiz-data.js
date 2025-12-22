const quizData = {
  dsa: {
    title: "Data Structures & Algorithms",
    questions: [
      {
        question: "What is the time complexity of binary search?",
        options: [
          "O(n)",
          "O(log n)",
          "O(n log n)",
          "O(n²)"
        ],
        correctAnswer: 1
      },
      {
        question: "Which data structure operates on the FIFO (First In First Out) principle?",
        options: [
          "Stack",
          "Queue",
          "Tree",
          "Heap"
        ],
        correctAnswer: 1
      },
      {
        question: "What is the worst-case time complexity for inserting an element in a binary search tree?",
        options: [
          "O(1)",
          "O(log n)",
          "O(n)",
          "O(n log n)"
        ],
        correctAnswer: 2
      },
      {
        question: "Which sorting algorithm has the best average-case performance?",
        options: [
          "Bubble Sort",
          "Insertion Sort",
          "Quick Sort",
          "Selection Sort"
        ],
        correctAnswer: 2
      },
      {
        question: "A full binary tree with n leaves contains how many nodes?",
        options: [
          "n",
          "2n",
          "2n-1",
          "2^n - 1"
        ],
        correctAnswer: 2
      },
      {
        question: "Which data structure is best suited for implementing a priority queue?",
        options: [
          "Array",
          "Linked List",
          "Heap",
          "Stack"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the time complexity of the breadth-first search (BFS) algorithm?",
        options: [
          "O(1)",
          "O(n)",
          "O(n+e) where e is the number of edges",
          "O(n²)"
        ],
        correctAnswer: 2
      },
      {
        question: "Which of the following is not an in-place sorting algorithm?",
        options: [
          "Bubble Sort",
          "Merge Sort",
          "Selection Sort",
          "Insertion Sort"
        ],
        correctAnswer: 1
      },
      {
        question: "What is the primary disadvantage of a linked list compared to an array?",
        options: [
          "Random access is not allowed",
          "Extra memory space for pointers",
          "Difficult to implement",
          "All of the above"
        ],
        correctAnswer: 0
      },
      {
        question: "What is the average time complexity of the hash table search operation?",
        options: [
          "O(1)",
          "O(log n)",
          "O(n)",
          "O(n log n)"
        ],
        correctAnswer: 0
      }
    ]
  },
  python: {
    title: "Python Programming",
    questions: [
      {
        question: "Which of the following is an immutable data type in Python?",
        options: [
          "List",
          "Dictionary",
          "Set",
          "Tuple"
        ],
        correctAnswer: 3
      },
      {
        question: "What will be the output of the following code?\nprint(type(lambda x: x))",
        options: [
          "<class 'function'>",
          "<class 'lambda'>",
          "<class 'method'>",
          "<class 'object'>"
        ],
        correctAnswer: 0
      },
      {
        question: "Which method is used to add an element at the end of a list in Python?",
        options: [
          "list.add()",
          "list.append()",
          "list.insert()",
          "list.extend()"
        ],
        correctAnswer: 1
      },
      {
        question: "What is the output of the following code?\n print(3 * '7')",
        options: [
          "21",
          "777",
          "7 7 7",
          "Error"
        ],
        correctAnswer: 1
      },
      {
        question: "Which of the following is used for handling exceptions in Python?",
        options: [
          "if-else",
          "try-catch",
          "try-except",
          "for-while"
        ],
        correctAnswer: 2
      },
      {
        question: "What does the __init__ method do in Python?",
        options: [
          "It's a constructor method",
          "It initializes the module",
          "It terminates the program",
          "It imports dependencies"
        ],
        correctAnswer: 0
      },
      {
        question: "What is a correct syntax to output 'Hello World' in Python?",
        options: [
          "echo('Hello World')",
          "printf('Hello World')",
          "print('Hello World')",
          "console.log('Hello World')"
        ],
        correctAnswer: 2
      },
      {
        question: "Which module in Python is used to work with dates?",
        options: [
          "time",
          "calendar",
          "datetime",
          "date"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the output of the following code?\nprint(5 // 2)",
        options: [
          "2.5",
          "2",
          "2.0",
          "Error"
        ],
        correctAnswer: 1
      },
      {
        question: "How do you create a virtual environment in Python?",
        options: [
          "py -v myenv",
          "python venv myenv",
          "python -m venv myenv",
          "virtualenv create myenv"
        ],
        correctAnswer: 2
      }
    ]
  },
  ai: {
    title: "Artificial Intelligence",
    questions: [
      {
        question: "Which search algorithm uses a heuristic function?",
        options: [
          "Depth-First Search",
          "Breadth-First Search",
          "A* Search",
          "Binary Search"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the primary goal of supervised learning?",
        options: [
          "Clustering similar data",
          "Predicting outcomes based on labeled data",
          "Learning from rewards and punishments",
          "Finding patterns without labeled data"
        ],
        correctAnswer: 1
      },
      {
        question: "Which of the following is NOT a type of machine learning?",
        options: [
          "Supervised Learning",
          "Unsupervised Learning",
          "Reinforcement Learning",
          "Descriptive Learning"
        ],
        correctAnswer: 3
      },
      {
        question: "What is the name of the algorithm that plays the game Go?",
        options: [
          "Deep Mind",
          "AlphaGo",
          "GoMaster",
          "DeepBlue"
        ],
        correctAnswer: 1
      },
      {
        question: "Which of the following is an example of a classification algorithm?",
        options: [
          "Linear Regression",
          "K-means",
          "Random Forest",
          "Principal Component Analysis"
        ],
        correctAnswer: 2
      },
      {
        question: "What does CNN stand for in AI?",
        options: [
          "Computer Neural Network",
          "Convolutional Neural Network",
          "Connected Neural Nodes",
          "Computational Neuron Network"
        ],
        correctAnswer: 1
      },
      {
        question: "Which technique is used to prevent overfitting in neural networks?",
        options: [
          "Gradient Descent",
          "Backpropagation",
          "Dropout",
          "Activation Function"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the Turing Test used for?",
        options: [
          "Testing computer processing speed",
          "Evaluating machine intelligence",
          "Measuring algorithm efficiency",
          "Comparing neural network architectures"
        ],
        correctAnswer: 1
      },
      {
        question: "Which AI approach attempts to mimic human reasoning?",
        options: [
          "Genetic Algorithms",
          "Expert Systems",
          "Neural Networks",
          "Reinforcement Learning"
        ],
        correctAnswer: 1
      },
      {
        question: "What is the name of the function that introduces non-linearity in neural networks?",
        options: [
          "Loss Function",
          "Cost Function",
          "Activation Function",
          "Gradient Function"
        ],
        correctAnswer: 2
      }
    ]
  },
  dbms: {
    title: "Database Management Systems",
    questions: [
      {
        question: "Which normal form eliminates transitive dependencies?",
        options: [
          "First Normal Form (1NF)",
          "Second Normal Form (2NF)",
          "Third Normal Form (3NF)",
          "Boyce-Codd Normal Form (BCNF)"
        ],
        correctAnswer: 2
      },
      {
        question: "What SQL command is used to create a new table?",
        options: [
          "CREATE TABLE",
          "BUILD TABLE",
          "GENERATE TABLE",
          "MAKE TABLE"
        ],
        correctAnswer: 0
      },
      {
        question: "Which of the following is NOT a type of SQL join?",
        options: [
          "INNER JOIN",
          "LEFT JOIN",
          "RIGHT JOIN",
          "PARALLEL JOIN"
        ],
        correctAnswer: 3
      },
      {
        question: "What is a foreign key?",
        options: [
          "A key that can be used to uniquely identify a row",
          "A key that connects to a primary key in another table",
          "A key used for encryption",
          "A key that contains multiple columns"
        ],
        correctAnswer: 1
      },
      {
        question: "Which ACID property ensures that a transaction is completed entirely or not at all?",
        options: [
          "Atomicity",
          "Consistency",
          "Isolation",
          "Durability"
        ],
        correctAnswer: 0
      },
      {
        question: "What type of index is most commonly used in databases?",
        options: [
          "Hash Index",
          "B-Tree Index",
          "Bitmap Index",
          "Full-Text Index"
        ],
        correctAnswer: 1
      },
      {
        question: "Which SQL statement is used to extract data from a database?",
        options: [
          "GET",
          "EXTRACT",
          "SELECT",
          "OPEN"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the main purpose of an SQL VIEW?",
        options: [
          "To increase database security",
          "To present data in a specific way",
          "To store temporary results",
          "All of the above"
        ],
        correctAnswer: 3
      },
      {
        question: "Which is NOT a valid type of database?",
        options: [
          "Relational Database",
          "NoSQL Database",
          "Object-Oriented Database",
          "Sequential Database"
        ],
        correctAnswer: 3
      },
      {
        question: "What does SQL stand for?",
        options: [
          "Structured Query Language",
          "System Query Language",
          "Standard Query Language",
          "Sequential Query Language"
        ],
        correctAnswer: 0
      }
    ]
  },
  cn: {
    title: "Computer Networks",
    questions: [
      {
        question: "Which layer of the OSI model is responsible for routing?",
        options: [
          "Data Link Layer",
          "Network Layer",
          "Transport Layer",
          "Session Layer"
        ],
        correctAnswer: 1
      },
      {
        question: "What protocol is used for secure web browsing?",
        options: [
          "HTTP",
          "FTP",
          "HTTPS",
          "SMTP"
        ],
        correctAnswer: 2
      },
      {
        question: "What is the maximum length of a UTP cable for Ethernet?",
        options: [
          "50 meters",
          "100 meters",
          "500 meters",
          "1000 meters"
        ],
        correctAnswer: 1
      },
      {
        question: "Which of the following is NOT a valid IP address?",
        options: [
          "192.168.1.1",
          "256.256.256.256",
          "10.0.0.1",
          "172.16.0.1"
        ],
        correctAnswer: 1
      },
      {
        question: "What protocol is used for transferring files over the Internet?",
        options: [
          "HTTP",
          "FTP",
          "SMTP",
          "DNS"
        ],
        correctAnswer: 1
      },
      {
        question: "Which network device operates at the data link layer?",
        options: [
          "Router",
          "Switch",
          "Gateway",
          "Firewall"
        ],
        correctAnswer: 1
      },
      {
        question: "What is the default subnet mask for a Class C IP address?",
        options: [
          "255.0.0.0",
          "255.255.0.0",
          "255.255.255.0",
          "255.255.255.255"
        ],
        correctAnswer: 2
      },
      {
        question: "Which protocol provides reliable data transmission?",
        options: [
          "UDP",
          "IP",
          "ICMP",
          "TCP"
        ],
        correctAnswer: 3
      },
      {
        question: "What protocol resolves IP addresses to MAC addresses?",
        options: [
          "DNS",
          "DHCP",
          "ARP",
          "RARP"
        ],
        correctAnswer: 2
      },
      {
        question: "Which topology provides the highest reliability?",
        options: [
          "Bus Topology",
          "Star Topology",
          "Ring Topology",
          "Mesh Topology"
        ],
        correctAnswer: 3
      }
    ]
  }
}; 