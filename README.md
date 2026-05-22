# Salesforce Branding Enrichment Package

A Salesforce DX demo project that enriches Account branding information using external logo retrieval, asynchronous Apex processing, Lightning Web Components (LWC), and custom logging.

This project demonstrates:
- Apex development
- LWC development
- Queueable Apex
- HTTP callouts
- Permission Set security
- Scratch org deployment
- Async processing patterns
- Packaging-aware development

---

# Features

- Custom Lightning Web Component on Account record pages
- Enrich Branding button for asynchronous branding retrieval
- External HTTP callout integration
- Queueable Apex processing
- Branding status tracking
- Branding log object for audit/history
- Permission-set-driven access
- Non-admin user support
- Scratch-org deployable Salesforce DX structure

---

# Architecture

```text
LWC (brandingPanel)
    ↓
BrandingController
    ↓
BrandingQueueable
    ↓
BrandingService
    ↓
BrandingHttpClient
    ↓
External Branding Provider
````

---

# Technologies Used

* Salesforce DX
* Apex
* Lightning Web Components (LWC)
* Queueable Apex
* HTTP Callouts
* Custom Objects
* Permission Sets
* FlexiPages
* Scratch Orgs
* Git / GitHub

---

# Project Structure

```text
force-app/main/default/
│
├── classes/
├── lwc/
├── objects/
├── permissionsets/
├── flexipages/
├── cspTrustedSites/
└── layouts/
```

---

# Main Components

## Apex Classes

| Class                  | Purpose                     |
| ---------------------- | --------------------------- |
| BrandingController     | Entry point for LWC actions |
| BrandingQueueable      | Async queueable processing  |
| BrandingService        | Branding business logic     |
| BrandingHttpClient     | HTTP callout handling       |
| BrandingDTO            | Data transfer object        |
| BrandingServiceTest    | Service test coverage       |
| BrandingControllerTest | Controller test coverage    |

---

# Custom Object

## Branding_Log__c

Stores:

* branding attempts
* status
* errors
* source record
* logo URL
* response details

---

# Screenshots

## Branding Panel

<img width="1192" height="552" alt="image" src="https://github.com/user-attachments/assets/1c2b7b95-8cae-42ad-a449-d50fb307fc15" />


## Successful Branding Enrichment

<img width="1272" height="561" alt="image" src="https://github.com/user-attachments/assets/3fcb051c-8d63-448e-9248-08b437219c03" />
<img width="1276" height="562" alt="image" src="https://github.com/user-attachments/assets/68f04beb-c89b-4602-9267-dc4c990de7dc" />

## Branding Logs

<img width="1197" height="852" alt="image" src="https://github.com/user-attachments/assets/ede93acb-ccb4-4518-b43e-66bef6f26312" />
<img width="1853" height="317" alt="image" src="https://github.com/user-attachments/assets/f187afe5-1c73-4a03-8488-c95f62b2a4cf" />


## Apex Test Results

<img width="493" height="607" alt="image" src="https://github.com/user-attachments/assets/6868719f-809f-4b5d-bd9f-4b4cf44b687d" />


## Permission Set Configuration

<img width="1418" height="522" alt="image" src="https://github.com/user-attachments/assets/2149929e-e69b-4c20-8bf3-17870233bbeb" />
<img width="1306" height="552" alt="image" src="https://github.com/user-attachments/assets/0d41a64d-4415-4774-be8a-536226d81ebe" />

---

# Setup Instructions

## 1. Create Scratch Org

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias BrandingScratch
```

---

## 2. Deploy Metadata

```bash
sf project deploy start --target-org BrandingScratch
```

---

## 3. Assign Permission Set

```bash
sf org assign permset --name Branding_Integration_User --target-org BrandingScratch
```

---

## 4. Open Org

```bash
sf org open --target-org BrandingScratch
```

---

# Post-Deployment Configuration

## Activate Lightning Record Page

After deployment:

Activate:

```text
Account Record Page
```

as:

```text
Org Default
```

because FlexiPage assignments may not reliably carry across org deployments.

---

# Required Permissions

Users require:

## Account Object

* Read
* Edit

## Branding_Log__c Object

* Read
* Create
* Edit

---

# Required Field Visibility

Users need visibility to:

## Account Fields

* Company_Domain__c
* Brand_Logo_URL__c
* Branding_Status__c

## Branding_Log__c Fields

* Domain__c
* Error_Message__c
* Logo_URL__c
* Response_Body__c
* Source_Object__c
* Source_Record_Id__c
* Status__c

---

# Required Apex Class Access

The permission set includes access to:

* BrandingController
* BrandingQueueable
* BrandingService
* BrandingHttpClient
* BrandingDTO

---

# Running Tests

```bash
sf apex run test --test-level RunLocalTests --target-org BrandingScratch --result-format human --code-coverage --synchronous
```

---

# Test Coverage

* 100% test pass rate
* ~81% org-wide code coverage

---

# Validation Checklist

After deployment verify:

* Branding panel appears on Account page
* Enrich Branding button works
* Branding status updates
* Logo URL updates
* Branding_Log__c records are created
* Non-admin users can access component

---

# Demo Purpose

This project was built as a demonstration of:

* Salesforce integration architecture
* asynchronous Apex processing
* Lightning Web Component development
* external HTTP callouts
* permission-set-driven access management
* Salesforce DX project structure

```
```
