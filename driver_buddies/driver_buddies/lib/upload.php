<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  // Replace these values with your database credentials
  $servername = " localhost:3308";
$username = "root@localhost";
$password = "";
$dbname = "data";


  // Create a connection to the MySQL database
  $conn = new mysqli($servername, $username, $password, $dbname);

  if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
  }

  $name = $_POST['name'];
  $email = $_POST['email'];
  $dob = $_POST['dob'];
  $aadhar = $_POST['aadhar'];
  $dl = $_POST['dl'];
  $issue_date = $_POST['issue_date'];
  $expiry_date = $_POST['expiry_date'];
  $referred_by = $_POST['referred_by'];
  $password = $_POST['password'];

  $sql = "INSERT INTO driver (name, email, dob, aadhar, dl, issue_date, expiry_date, referred_by, password) 
          VALUES ('$name', '$email', '$dob', '$aadhar', '$dl', '$issue_date', '$expiry_date', '$referred_by', '$password')";

  if ($conn->query($sql) === TRUE) {
    echo "Data inserted successfully!";
  } else {
    echo "Error: " . $sql . "<br>" . $conn->error;
  }

  $conn->close();
} else {
  echo "Invalid request method";
}
?>
