# Amazon SQS: Simple Queue Service

### What is poll-based Messaging:

### What is SQS:
Simple Queue Service is a messaging queue that allows asynchronous processing of work.
One resource will write a message to an SQS queue, and then another resource 
will retrieve that message from SQS.

### SQS settings:
1. Delivery Delay: default is 0 and max is 15 minutes.
2. Message Size: Messages can be up to 256 kb of text in any format.
3. Encryption: Messages are encrypted in transit by default, but you can add at-rest.\
4. Message Retention: Default is 4 days; can be set between 1 minute and 14 days. 
    after this period of time, the message will be purged from the queue.
5. Polling - Short vs Long: 
   1. default is Short polling => short polling the ReceiveMessage 
      sends the response right away, even of the query found no messages.
   2. Long polling, the ReceiveMessage sent an empty response only if the polling wait time expoires.
6. Queue depth: This can be a trigger for autoscaling
7. Visibility Timeout: 


### Dead-Letter Queue - DLQ:
Another SQs that 
