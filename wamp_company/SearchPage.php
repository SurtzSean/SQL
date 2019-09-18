<?php
    //connecting to wamp server and mysql database
    $conn = mysqli_connect("localhost","root","","Company");
    if(!$conn) die("connection failed");
?>

<html>
    <head>
        <title>Employee Search Results</title>
    </head>
<body>
<?php
    $query = $_GET['query'];
    $select = "SELECT * FROM employee WHERE upper(Last_Name) = upper('$query')";//select where search is last name is the same as searched name
    if($result=mysqli_query($conn,$select))
    {
        if($result->num_rows!=0){
            echo "<h1>Company Database Search Results</h1>";
            echo "<table>";
            echo "<th> First Name</th>";
            echo "<th> Last Name</th>";
            echo"<th>Sex</th>";
            echo"<th>Dno</th>";
            while($row=mysqli_fetch_array($result)){
                echo "<tr>";
                echo "<td>".$row['First_Name']."</td>";
                echo "<td>".$row['Last_Name']."</td>";
                echo "<td>".$row['Sex']."</td>";
                echo "<td>".$row['DNO']."</td>";
                echo "</tr>";
            }
            echo "</table>";
        }
        else {
            echo "<p>No records found</p>";
        }
    }
    else{
        echo "<p>Syntax Error</p>";
    }
?>
</body>
</html>