1. you can create up to 100 buckets by default
2. buckets must be in a region
3. buckets have subresources that basically define how the bucket is configured -> a subresource is
   a resource that belongs to another resource and cannot exist on its own.
4. S3 hasa universal namespace
5. S3 is a key, value store designed to store unlimited numbers of objects.
6. an object consist of:
   a. key: name of the object b. value: the data being stored 0-5TB c. version id: a string of data
   assigned to an object when versioning is enabled d. metadata: name-value pairs which are used to
   store information about the object e. subresources: additional resources specifically assigned to
   an object f. access control information: policies of controlling access to the resource.
7. s3 has a flat structure - but you can use prefixed
8. you can use object tagging to tag your objects

9. S3 provides stronge consistency for puts, lists, and delete objects => after any of these
   operations are performed any subsequent read request immediately receives the latest version of
   the object - prior to 2020 S3 provide eventual consistency for objects

10. S3 does not provide object locking

Security:

11. S3 objects are secure by default. Only the bucket and object owners have access to the resource
    they create.
12. all access to S3 resources can be optionally logged to provide audits trails.

Storage Class:

13. If you don't specify a storage class upon creation the STANDARD storage class will be used by
    default.
14. STANDARD, REDUCED_REDUNDANCY - less durability but its a legacy and comes with higher cost =>
    Frequently accessed objects
15. STANDARD_IA, ONEZONE_IA => Infrequenlty accessed objects- IA
16. GLACIER, DEEP_ARCHIVE => Rarely Accessed objects
17. INTELLIGENT_TIERING object size > 128kb

Lifecycle Policies: allow objects to transition from between the storage classes
