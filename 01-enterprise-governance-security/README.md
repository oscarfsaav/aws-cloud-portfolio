# Project 01: AWS Enterprise Governance & Security Foundation

## 📝 Overview
This foundational project demonstrates the establishment of a secure, production-ready, multi-account AWS environment. It aligns with the **AWS Well-Architected Framework**, specifically focusing on the **Security** and **Cost Optimization** pillars. 

The primary goal of this architecture is to minimize the "blast radius" by separating operational environments, enforce Zero Trust principles for identity management, and implement basic FinOps practices before deploying any cloud resources.

## 🏗️ Architecture & Services Used
* **AWS Organizations:** Multi-account management and structural isolation.
* **AWS IAM (Identity and Access Management):** Access control, group-based policies, and custom login aliases.
* **AWS Budgets:** Proactive financial governance and cost anomaly detection.
* **AWS Billing and Cost Management:** Consolidated billing and IAM access delegation.

## 🚀 Key Implementations

### 1. Multi-Account Strategy & Blast Radius Isolation
* Implemented **AWS Organizations** to transition from a single-account setup to a Management/Member account hierarchy.
* Created a dedicated Member Account (`Portfolio-Dev-Cloud`) to isolate development and portfolio workloads from the Management Account, ensuring a secure blast radius and clean environment separation.
* Enabled **Consolidated Billing** to centralize cost tracking at the Organizational level.

### 2. Financial Governance (FinOps)
* Delegated billing access to IAM roles to ensure operational admins have visibility into resource costs.
* Configured a **Zero-Spend Budget** ($1.00 threshold) in the Management Account using AWS Budgets to monitor the unified cost of the entire Organization.
* Automated email alerts triggered upon exceeding the Free Tier limits or generating unexpected billing.

### 3. Identity & Access Management (Zero Trust)
* **Root Account Securitization:** Enforced hardware/virtual Multi-Factor Authentication (MFA) on the Root user of both the Management and Member accounts. Exiled Root accounts from daily operations.
* **Group-Based Access:** Created a `DevOps-Admins` IAM User Group attached to the `AdministratorAccess` managed policy, adhering to the best practice of avoiding direct policy attachments to individual users.
* **Operational Identity:** Provisioned a dedicated IAM User for daily operations, secured with an independent MFA token.
* **Custom Login URL:** Configured an Account Alias (`portfolio-dev-cloud`) to provide a standardized, human-readable console sign-in link for IAM users.

## 🧠 Lessons Learned & Best Practices
* **Never use the Root user** for daily tasks; always rely on IAM identities with delegated permissions.
* Budgets in AWS Organizations do not visually inherit in Member Accounts, but a global budget in the Management Account successfully monitors the aggregate spend.
* Establishing cost guardrails *before* deploying infrastructure is critical to prevent unexpected charges, especially when working with self-managed cloud environments.