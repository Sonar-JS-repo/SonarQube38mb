#!/bin/bash
echo "" > tempfile
echo -e "<!DOCTYPE html>
<html>
<head>
<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}
td, th {
  border: 1px solid #003366;
  text-align: left;
  padding: 8px;
}
tr:nth-child(even) {
  background-color: #DDDDDD;
}
</style>
</head>
<body>
<h1 style=\"color:Tomato;\">SonarQube Analysis Report</h1>
<table>
  <tr>
    <th style=\"background-color:#1accd9;\">Metrics</th>
    <th style=\"background-color:#1accd9;\">Vaule</th>
  </tr>" >> tempfile
name=`cat sonar.json |jq ".component.name"`
echo "<h2>Project Name -  $name<h2>" >> tempfile
for i in {0..9};
do
item=`cat sonar.json |jq ".component.measures[$i].metric"`
value=`cat sonar.json |jq ".component.measures[$i].value"`
echo "<tr>" >> tempfile
echo  "<td>$item</td><td>$value</td>" >> tempfile
echo  "</tr>" >> tempfile
sed -i 's/\"//g' tempfile
done
