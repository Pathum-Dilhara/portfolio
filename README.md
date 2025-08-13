# 🚀 React CI/CD Deployment to AWS S3 with Terraform & GitHub Actions (Access Keys)
This project demonstrates a **fully automated CI/CD pipeline** for deploying a Web application to an AWS S3 bucket using:

##Architecture Diagram

![image](https://github.com/user-attachments/assets/4c26a75b-e11f-4047-a414-f658c349467d)

- **React** → Frontend app
- **AWS S3** → Static website hosting
- **Terraform** → Infrastructure as Code (S3 bucket, IAM User, Access Keys)
- **GitHub Actions** → CI/CD using stored AWS access keys
  
##🖼 Example CI/CD Flow Diagram
```
[ Developer Push ]
        ↓
[ GitHub Actions Pipeline ]
        ↓ (AWS Access Keys from Secrets)
[ aws s3 sync build/ → S3 Bucket ]
        ↓
[ Website Updated ]
```
##🌐 Access your website
```
http://<bucket-name>.s3-website-<region>.amazonaws.com
```
