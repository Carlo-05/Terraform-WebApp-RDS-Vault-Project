
output "public-subnet-1" {
  value = aws_subnet.Public-1.id
  
}
output "public-subnet-2" {
  value = aws_subnet.Public-2.id
  
}
output "private-subnet-1" {
  value = aws_subnet.Private-1.id
  
}
output "private-subnet-2" {
  value = aws_subnet.Private-2.id
  
}

output "MyVPC" {
  value = aws_vpc.MyVPC.id
  
}

output "private-route-table" {
  value = aws_route_table.Private-Route-Table.id
  
}

output "public-route-table" {
  value = aws_route_table.Public-Route-Table.id
  
}