MonitoFi is a tool that monitors the health and performance of Apache NiFi clusters. This tool runs separately from NiFi. MonitoFi provides information in two formats:

- Dashboards display historic information on the state of clusters.
- Real-time notifications alert users when the tool detects anomalies.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Key benefits

MonitoFi offers these qualities:

- Lightweight and extensible: MonitoFi is a lightweight tool that runs externally. Because it's based on Python and is containerized, you can extend MonitoFi to add features. A MonitoFi instance that runs in one container can target multiple NiFi clusters.
- Flexible and robust: MonitoFi uses a REST API wrapper to retrieve JSON data from NiFi. MonitoFi converts that data into a usable format that doesn't depend on specific endpoints or field names. As a result, when NiFi REST API responses change, you don't need to change MonitoFi code.
- Easy to adopt: You don't have to reconfigure existing NiFi clusters to start using MonitoFi to monitor them.

MonitoFi provides these features and benefits:


















