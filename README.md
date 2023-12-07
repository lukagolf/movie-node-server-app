# Set up MySQL server

### Step 1: Update Database Credentials
- **File**: `path/to/movie-node-server-app/db/nodejs-connect/mysql-connect.js`
- **File**: `path/to/movie-node-server-app/app.js`
- **Action**: Replace the `user` and `password` fields with your own MySQL username and password.

### Step 2: Start MySQL Server
- **Action**: Start your MySQL server.
- **Tool**: Open MySQL Workbench.

### Step 3: Execute SQL Dump
- **File**: `path/to/movie-node-server-app/db/projectdump.sql`
- **Action**: Open and execute this file in your MySQL Workbench.

### Step 4: Alter MySQL User Settings
- **Action**: Open a new query tab in MySQL Workbench.
- **Commands**:
  ```
  ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'root';
  FLUSH PRIVILEGES;
  ```
  **Note**: Replace `root` with your own username and password, if different.



# Run a Node server using Docker

### Step 0: Install Docker
- Before you begin, ensure that Docker is installed on your system. Docker is available for Windows, macOS, and various distributions of Linux.
- To install Docker, visit the [Docker official website](https://www.docker.com/get-started) and download the appropriate installer for your operating system.
- Follow the installation instructions provided on the website to install Docker on your machine.

### Step 1: Navigate to the Backend Repository
- Open a terminal.
- Change directory to the root of the backend repository (`movie-node-server-app`).
  ```
  cd path/to/movie-node-server-app
  ```

### Step 2: Build the Docker Image
- Build the Docker image using the provided Dockerfile. This image will contain your Node.js application and all its dependencies.
  ```
  docker build -t movie-node-server .
  ```

### Step 3: Run the Docker Container
- Once the image is built, run the container. This command starts the Node.js server inside the container, mapping the server's port to a port on the host machine.
  ```
  docker run -p 4000:4000 movie-node-server
  ```
- The server should now be accessible at `http://localhost:4000`.