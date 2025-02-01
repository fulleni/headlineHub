## ⚙️📡🔐 HeadlineHub API 🔐📡⚙️

**🐸 A Dart Frog API for the HeadlineHub app and dashboard**

This repository contains the source code for the HeadlineHub API, a RESTful API built with Dart Frog, serving as the backend for both the HeadlineHub mobile app and the HeadlineHub web dashboard. 

**🚧 Current Status**

The HeadlineHub API is currently under development. The features listed below are planned and may not all be implemented in the current version.

**🚀 Features (Planned)**

* **📡 News Source Management API:**
    * ➕ Create, read, update, and delete news sources.
    * ⚙️ Configure source-specific settings (e.g., polling frequency, filtering rules, API keys).
    * 🩺 Monitor source health and status.
* **👥 User Management API:**
    * 👤 User registration, login, and logout endpoints.
    * 🔒 Role-based access control (e.g., admin, editor, user).
    * 🔑 Secure authentication and authorization using JWTs.
* **📝 Headline Management API:**
    * ➕ Create, read, update, and delete headlines.
    * 📝 Fetch headlines from integrated news sources (e.g., News API).
    * 🔄 Schedule headline publication times.
    * ✅ Publish and unpublish headlines.
    * ⚠️ Handle headline approval and rejection workflows.
* **📊 App Analytics API:**
    * 📈 Track user engagement metrics (e.g., active users, daily active users, session duration).
    * 📈 Track headline popularity metrics (e.g., most read headlines, top sources).
    * 📊 Provide aggregated usage statistics.

**🏗️ Architecture**

* **🧹 Clean Architecture:** Adhering to clean architecture principles for separation of concerns.
* **💉 Dependency Injection:** Utilizing dependency injection for better testability and maintainability.
* **💾 Data Persistence:** Utilizing a suitable database (e.g., PostgreSQL) for data storage and retrieval.

**🛠️ Technologies**

* **🎯 Dart:** The programming language for both frontend and backend development.
* **🐸 Dart Frog:** A modern and performant Dart framework for building backend applications.
* **🐘 PostgreSQL:** The chosen database system for data persistence.
* **🔐 JWT:** JSON Web Tokens for secure authentication and authorization.

**⚠️ Disclaimer**

This API is currently under development and may contain bugs or have limited functionality.

## 📝 License

HeadlineHub app offers a [PolyForm-Free-Trial](https://polyformproject.org/licenses/free-trial/1.0.0/) license provided with the source code. Users can seamlessly upgrade to the robust [PolyForm-Perimeter](https://polyformproject.org/licenses/perimeter/1.0.1/) license with a single, [one-time payment](https://polar.sh/headlinehub/).

### Understanding the PolyForm Free Trial License
This evaluation license provides a 32-day period for comprehensive assessment and modification of the code's functionality. Continued utilization beyond this evaluation period necessitates the acquisition of a [PolyForm-Perimeter](https://polyformproject.org/licenses/perimeter/1.0.1/) license.

### Understanding the PolyForm Perimeter License
This license grants unlimited rights to utilize, modify, and distribute derivatives of the licensed source code, expressly prohibiting the distribution of the source code itself, whether for commercial gain or without charge.

### Do I need separate licenses for the HeadlineHub app and dashboard?
**No**, a single [license](https://polar.sh/headlinehub/) covers all three.

---
Should you have any further questions, please do not hesitate to inquire [here](https://github.com/headlinehub/api/issues)."
