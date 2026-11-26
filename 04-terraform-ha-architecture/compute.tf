# --- Imagen: ultima Amazon Linux 2023 (AWS publica su ID en un parametro publico) ---
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# --- Rol de IAM para los servidores: solo acceso a Systems Manager ---
resource "aws_iam_role" "web" {
  name = "ha-web-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "web" {
  name = "ha-web-profile"
  role = aws_iam_role.web.name
}

# --- Launch Template: la "receta" de cada servidor web ---
resource "aws_launch_template" "web" {
  name_prefix   = "ha-web-"
  image_id      = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.web.name
  }

  # IMDSv2 obligatorio
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # El replace evita problemas si el archivo se guardo con saltos de linea de Windows
  user_data = base64encode(replace(file("${path.module}/user-data.sh"), "\r\n", "\n"))

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "ha-web" }
  }
}