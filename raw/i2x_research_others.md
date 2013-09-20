#### COEUS
COEUS is a new semantic web framework, aiming at a streamlined application development cycle and following a "semantic web in a box" approach. The framework provides a single package including advanced data integration and triplification tools, base ontologies, a web-oriented engine and a flexible exploration API. Resources can be integrated from heterogeneous sources, including CSV and XML files or SQL and SPARQL query results, and mapped directly to one or more ontologies. Advanced interoperability features include REST services, a SPARQL endpoint and LinkedData publication. These enable the creation of multiple applications for web, desktop or mobile environments, and empower a new knowledge federation layer.
The platform, targeted at biomedical application developers, provides a complete skeleton ready for rapid application deployment, enhancing the creation of new semantic information systems.

##### Key Features

- Semantic abstraction/translation
- Multiple integration connectors
- Base engine for i2x

**URL**: [http://bioinformatics.ua.pt/coeus/](http://bioinformatics.ua.pt/coeus/ "COEUS")
  
#### Bio2RDF
The Bio2RDF project uses a data integration approach based on semantic web rules to answer a broad question: What is known about the mouse and human genomes? Using its *rdfizing* services, a semantic mashup of 65 million triples was built from 30 public bioinformatics data providers: GO, NCBI, UniProt, KEGG, PDB and many others. The average link-rank (ALR) of a node is 4.7 which means that a usual topic is connected to 4.7 other topics by direct or reverse links within the warehouse.

##### Key Features

- Covers lots of data types
- PHP-based rdfization
- Growing popularity

**URL**: [http://bio2rdf.org](http://bio2rdf.org "Bio2RDF")
 
#### Kettle
Pentaho Data Integration delivers powerful Extraction, Transformation and Loading (ETL) capabilities using an innovative, metadata-driven approach. With an intuitive, graphical, drag and drop design environment, and a proven, scalable, standards-based architecture, Pentaho Data Integration is increasingly the choice for organizations over traditional, proprietary ETL or data integration tools.

##### Key Features

- ETL tools for lots and lots of data types, from file readers (CSV, XML...) to database connectors (MySQL, SQL Server, ...)
- Comprehensive GUI (Desktop)
- Widely used in Enterprise, critical component for Pentaho business suite

**URL**: [http://kettle.pentaho.com/](http://kettle.pentaho.com/ "Kettle")
 
#### Taverna
**Taverna** is an open source and domain-independent Workflow Management System – a suite of tools used to design and execute scientific workflows and aid _in silico_ experimentation. Taverna enables the creation of extremely complex workflows using a rich set of activities.

##### Key Features

 - Comprehensive GUI (Desktop)
 - Lots and lots of activities for inclusion in any workflow
    - From REST web services to custom Java code
- Widely used in the biomedical domain

**URL**: [http://www.taverna.org.uk/](http://www.taverna.org.uk/ "Taverna")
 
#### Galaxy
**Galaxy** is an open, web-based platform for data intensive biomedical research. Whether on the free public server or custom  instances, anyone can perform, reproduce, and share complete analyses.

##### Key Features

- Excellent web-based GUI for complex workflows
- Cloud-based approach (online reproducible research)
- Sharing and collaboration environments

**URL**: [http://galaxyproject.org/](http://galaxyproject.org/ "Galaxy")
 
#### IFTTT
**IFTTT** is a service that lets you create powerful connections with one simple statement: **If This Then That**.

##### Key Features

- Multiple input and output services
- Focus on social tools (networks, blogs...)
- Mobile application
- Very very easy to use

**URL**: [http://www.ifttt.com](http://www.ifttt.com "IFTTT")
 
#### Zapier
**Zapier** enables you to automate tasks between other online services (services like Salesforce, Basecamp, Gmail, and 223 more). Imagine capturing Wufoo form leads automatically into Salesforce or displaying new Paypal sales in your Campfire team chat room. Zapier lets you automate all these simple tasks and get back to real work.

##### Key Features

- Lots and lots of input/output services
- Focus on integrating business services
- Very easy to use

**URL**: [https://zapier.com/](https://zapier.com/ "Zapier")
 
#### Huginn
Huginn is a system for building agents that perform automated tasks for you online. They can read the web, watch for events, and take actions on your behalf. Huginn's Agents create and consume events, propagating events along a directed event flow graph. Think of it as Yahoo! Pipes plus IFTTT on custom servers.

##### Key Features

- Ruby open-source code
- Still in its infancy
- Agent-based

**URL**: [https://github.com/cantino/huginn](https://github.com/cantino/huginn "Huginn")
 
#### Elastic.io
**Elastic.io** is a cloud integration platform that enables ISVs to fill their integration AppStore in minutes not days. ISVs will get more revenues, users and will reduce costs whilst keeping the end-user relationship and getting actionable insights.

##### Key Features

 - Still early days
 - Business-oriented

**URL**: [http://www.elastic.io/](http://www.elastic.io/ "Elastic.io")
 
#### AX-InCoDa

#####Active XML-based Web data integration
 There is currently a strong trend for decision-making applications such as Data Warehousing (DW) and Business Intelligence (BI) to move onto the Web, especially in the cloud. Integrating data into DW/BI applications is a critical and time-consuming task. To make better decisions in DW/BI applications, next generation data integration poses new requirements to data integration systems, over those posed by traditional data integration. In this paper, we propose a generic, metadata-based, service-oriented, and event-driven approach for integrating Web data timely and autonomously. Beside handling data heterogeneity, distribution and interoperability, our approach satisfies near real-time requirements and realize active data integration. For this sake, we design and develop a framework that utilizes Web standards (e.g., XML and Web services) for tackling data heterogeneity, distribution and interoperability issues. Moreover, our framework utilizes Active XML (AXML) to warehouse passive data as well as services to integrate active and dynamic data on-the-fly. AXML embedded services and changes detection services ensure near real-time data integration. Furthermore, the idea of integrating Web data actively and autonomously revolves around mining events logged by the data integration environment. Therefore, we propose an incremental XML-based algorithm for mining association rules from logged events. Then, we define active rules dynamically upon mined data to automate and reactivate integration tasks. Finally, as a proof of concept, we implement a framework prototype as a Web application using open-source tools.

##### Key Features

- Complete architecture
- Framework similar to i2x
- Only uses ActiveXML

**URL**: [http://link.springer.com/article/10.1007/s10796-012-9405-6](http://link.springer.com/article/10.1007/s10796-012-9405-6 "Springer Publication")
 
#### Naeem et. al.

##### An event-based near real-time data integration architecture
Extract-transform-load (ETL) tools feed data from operational databases into data warehouses. Traditionally, these ETL tools use batch processing and operate offline at regular time intervals, for example on a nightly or weekly basis. Naturally, users prefer to have up-to-date data to make their decisions, therefore there is a demand for real-time ETL tools. In this paper we investigate an event-based near real-time ETL layer for transferring and transforming data from the operational database to the data warehouse. One of our main concerns in this paper is master data management in the ETL layer. We present the architecture of a novel, general purpose, event-driven, and near real-time ETL layer that uses a database queue (DBQ), works on a push technology principle and directly supports content enrichment. We also observe that the system architecture is consistent with the information architecture of a classical online transaction processing (OLTP) application, allowing us to distinguish between different kinds of data to increase the clarity of the design.

##### Key Features

- Automated ETL
- Real time (without polling, just data being *push*ed)

**URL**: [http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=4815048&tag=1](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=4815048&tag=1 "IEEE Publication")
 
#### Mouttham et. al.

#####Event-Driven Data Integration for Personal Health Monitoring
The emergence of biomedical wireless sensors, the wide spread use of smartphones, and advanced data stream mining techniques have enabled a new generation of personal health monitoring systems. These health monitoring systems are mostly stand-alone and are not yet integrated with existing e-Health systems, which could seriously limit their large scale deployment. In this paper, we propose an architecture for data integration within an electronic health care network based on extending the traditional SOA approach with support for complex event processing and context awareness. This architecture also facilitates integrated business performance management against quality of care targets. A detailed health monitoring scenario for the care of cardiac patients is used to illustrate system requirements and to validate the proposed architecture. The expected benefits of our approach include a higher quality of care, reduced costs for health service providers and a higher quality of life for the patients. 

##### Key Features

- Just a concept
- Applied to personal health monitoring/life sciences

**URL**: [https://www.academypublisher.com/~academz3/ojs/index.php/jetwi/article/view/0102110118](https://www.academypublisher.com/~academz3/ojs/index.php/jetwi/article/view/0102110118)

 