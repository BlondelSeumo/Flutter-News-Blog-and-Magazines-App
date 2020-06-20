<?php 
    class DB {
        // The database connection
        protected static $connection;

        /**
         * Connect to the database
         * 
         * @return bool false on failure / mysqli MySQLi object instance on success
         */
        public function connect() {    
            // Try and connect to the database
            if(!isset(self::$connection)) {
                // Load configuration as an array. Use the actual location of your configuration file
                $config = parse_ini_file('config.ini'); 
                self::$connection = new mysqli('localhost',$config['username'],$config['password'],$config['dbname']);
            }

            // If connection was not successful, handle the error
            if(self::$connection === false) {
                // Handle error - notify administrator, log to a file, show an error screen, etc.
                return false;
            }
            return self::$connection;
        }

        /**
         * Query the database
         *
         * @param $query The query string
         * @return mixed The result of the mysqli::query() function
         */
        public function query($query) {
            // Connect to the database
            $connection = $this -> connect();
			$result = $connection -> query("SET NAMES 'utf8'");
            // Query the database
            $result = $connection -> query($query);

            return $result;
        }


        /**
         * Query the database
         *
         * @param $query The query string
         * @return mixed The result of the mysqli::query() function
         */
        public function check($query) {
            // Connect to the database
            $connection = $this -> connect();

            // Query the database
            $result = $connection -> query($query);
			$check = mysqli_num_rows($result);
            return $check;
        }

        /**
         * Fetch rows from the database (SELECT query)
         *
         * @param $query The query string
         * @return bool False on failure / array Database rows on success
         */
        public function select($query) {
            $rows = array();
            $result = $this -> query($query);
            if($result === false) {
                return false;
            }
            while ($row = $result -> fetch_assoc()) {
                $rows[] = $row;
            }
            return $rows;
        }

        /**
         * Fetch the last error from the database
         * 
         * @return string Database error message
         */
        public function error() {
            $connection = $this -> connect();
            return $connection -> error;
        }
		
		
        /**
         * Get number of affected rows in previous MySQL operation
         * 
         * @return string Database error message
         */
        public function affected() {
            $connection = $this -> connect();
            return $connection -> affected_rows;
        }
		
		/**
         * Fetch the last Insert Id from the database
         * 
         * @return insert_id from Database
         */
        public function insert_id() {
            $connection = $this -> connect();
            return $connection -> insert_id;
        }

        /**
         * Quote and escape value for use in a database query
         *
         * @param string $value The value to be quoted and escaped
         * @return string The quoted and escaped string
         */
        public function quote($value) {
            $connection = $this -> connect();
            return "'" . $connection -> real_escape_string($value) . "'";
        }

        /**
         * Quote and escape value for use in a database query
         *
         * @param string $value The value to be quoted and escaped
         * @return string The quoted and escaped string
         */
        public function escape_text($value) {
            $connection = $this -> connect();
            return $connection -> real_escape_string($value);
        }
    }
?> 