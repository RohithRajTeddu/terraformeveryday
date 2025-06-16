resource "aws_s3_bucket" "s3_locking" {
  bucket = "locking_rohith"

}

resource "aws_dynamodb_table" "dynamo_locking" {
  name = "dynamo_locking_state_file"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}