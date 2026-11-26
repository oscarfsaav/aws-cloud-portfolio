# ☁️ Portfolio de Cloud en AWS

Proyectos propios que acompañan mis certificaciones y documentan, con diagramas, decisiones de diseño y evidencias, lo que he construido en AWS.

**Óscar Fragueiro Saavedra** · Junior Cloud Engineer · Madrid

🌐 [oscarfragueiro.com](https://oscarfragueiro.com) · 💼 [LinkedIn](https://linkedin.com/in/oscarfragueiro)

## 🎓 Certificaciones

- **AWS Certified Solutions Architect – Associate (SAA-C03)**, noviembre de 2026
- **AWS Certified Cloud Practitioner**

Mi formación en cloud es autodidacta, a través del curso y los laboratorios de Adrian Cantrill y de los proyectos de este repositorio. Vengo del desarrollo de software (CFGS en Desarrollo de Aplicaciones Multiplataforma) y tengo experiencia previa con Linux, Python y APIs REST.

## 📂 Proyectos

| # | Proyecto | Servicios principales | Método | Estado |
| :-: | :--- | :--- | :--- | :--- |
| 01 | [Base de seguridad y control de costes de la cuenta](./01-enterprise-governance-security) | Organizations, IAM, Budgets | Consola | ✅ Configurado |
| 02 | [Cloud Resume Challenge](./02-cloud-resume-challenge) | Route 53, ACM, CloudFront, S3, API Gateway, Lambda, DynamoDB, IAM | Consola | ✅ En producción en [oscarfragueiro.com](https://oscarfragueiro.com) |
| 03 | [Arquitectura web de alta disponibilidad](./03-high-availability-architecture) | VPC, ALB, EC2, NAT Gateway, Security Groups, EC2 Instance Connect Endpoint | Consola | 📄 Documentado (entorno eliminado para evitar costes) |
| 04 | [Alta disponibilidad con Terraform](./04-terraform-ha-architecture) | VPC, ALB, Auto Scaling Group, ACM, Route 53, Systems Manager, IAM | Terraform | 📄 Documentado, con prueba de fallo (entorno eliminado con `terraform destroy`) |

## 🧭 Cómo trabajo

- **Primero a mano, después automatizado.** Despliego cada arquitectura desde la consola para entender cómo se comporta cada servicio, y después la reconstruyo con infraestructura como código (el proyecto 04 es la versión en Terraform del 03, que corrige varias de las limitaciones de aquel).
- **Cada proyecto explica el porqué.** Los README incluyen el diagrama, las decisiones de seguridad y diseño, los problemas que encontré, las evidencias y las **limitaciones conocidas** de lo que construí.
- **Costes bajo control.** Los entornos que se cobran por hora se eliminan en cuanto están documentados.

## 🔮 Próximos pasos

- Una aplicación backend completa en AWS (**Java/Spring Boot + PostgreSQL**) con contenedores, base de datos gestionada, secretos y alarmas, todo con Terraform.
- **CI/CD** con GitHub Actions.
