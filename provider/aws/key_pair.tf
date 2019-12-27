resource "aws_key_pair" "horizon-kp" {
    key_name = "aws_ssh_key"
    public_key = file("/app/horizon-public/provider/aws/mykeys/aws_ssh_key.pem.pub")
}

