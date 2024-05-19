Design Decisions:
User Interface: The app follows a minimalist design approach to ensure simplicity and ease of use for users.
Color Scheme: Utilizes a dark theme with contrasting colors to enhance visibility and reduce eye strain.
Navigation: Implements a bottom navigation bar for easy access to different sections of the app.
Data Presentation: Presents expenses in a list view with clear categorization and sorting options for better organization.

Architectural Choices:
1. Flutter Framework:
Cross-Platform Development: Flutter was selected due to its ability to build natively compiled applications for mobile, web, and desktop platforms from a single codebase.
Rich UI Components: Flutter offers a wide range of customizable widgets and material design components, allowing for the creation of visually appealing and responsive user interfaces.
Hot Reload: The hot reload feature of Flutter facilitates rapid development by allowing developers to instantly view changes made to the code without restarting the app.
2. Database Management:
SQLite Database: SQLite was chosen as the local database solution for storing expense data due to its lightweight nature and ease of integration with Flutter using the sqflite package.
Data Persistence: By storing data locally, the app ensures that expense records remain accessible even when the device is offline, providing a seamless user experience.
3. Architecture Pattern:
Model-View-Controller (MVC): The app follows the MVC architectural pattern to separate concerns and improve maintainability.
Model: Represents the data structure and business logic, including expense entities and database operations.
View: Presents the user interface elements and interacts with the user, displaying expense data and allowing for user input.
Controller: Acts as an intermediary between the model and view, handling user input, updating the model, and triggering UI updates accordingly.
4. Dependency Management:
Pub Package Manager: Utilizes the pub package manager to manage dependencies and integrate third-party packages into the project.
Package Modularity: Selects packages that offer specific functionality required for the app, ensuring modularity and avoiding unnecessary bloat in the codebase.
5. Error Handling and Logging:
Error Reporting: Implements error handling mechanisms to gracefully handle exceptions and prevent app crashes, providing informative error messages to users when necessary.
Logging: Incorporates logging functionality to track app events, debug issues, and monitor performance during development and testing phases.
6. Scalability and Maintainability:
Code Organization: Structures the codebase into modular components and follows best practices for naming conventions, file organization, and code documentation to enhance readability and maintainability.
Future Scalability: Designs the app architecture with scalability in mind, allowing for easy integration of additional features and enhancements in future iterations.

Testing Approach:
Unit Testing: Conducts unit tests for critical functions and classes using the Flutter test framework.
Widget Testing: Tests individual UI components and widgets to ensure proper rendering and functionality.
Integration Testing: Performs integration tests to validate interactions between different parts of the app.
User Testing: Engages real users to provide feedback and identify usability issues through beta testing.
