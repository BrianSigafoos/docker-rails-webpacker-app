# Kubernetes Security

## NSA/CISA Kubernetes Hardening Guidance

A summary of the key recommendations from each section are:

- Kubernetes Pod security
  - [x] Use containers built to run applications as non-root users
  - [ ] Where possible, run containers with immutable file systems
  - [ ] Scan container images for possible vulnerabilities or misconfigurations
  - [ ] Use a [Pod Security Policy (deprecated 1.21)](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) -> [Pod Security admission controller (new 1.22)](https://kubernetes.io/docs/concepts/security/pod-security-admission/) to enforce a minimum level of security
        including:
    - [ ] Preventing privileged containers
    - [ ] Denying container features frequently exploited to breakout, such
          as hostPID, hostIPC, hostNetwork, allowedHostPath
    - [ ] Rejecting containers that execute as the root user or allow
          elevation to root
    - [ ] Hardening applications against exploitation using security services
          such as SELinux®, AppArmor®, and seccomp
- Network separation and hardening
  - [ ] Lock down access to control plane nodes using a firewall and role-based
        access control (RBAC)
  - [ ] Further limit access to the Kubernetes etcd server
  - [ ] Configure control plane components to use authenticated, encrypted
        communications using Transport Layer Security (TLS) certificates
  - [ ] Set up network policies to isolate resources. Pods and services in different
        namespaces can still communicate with each other unless additional
        separation is enforced, such as network policies
  - [ ] Place all credentials and sensitive information in Kubernetes Secrets
        rather than in configuration files. Encrypt Secrets using a strong
        encryption method
- Authentication and authorization
  - [ ] Disable anonymous login (enabled by default)
  - [ ] Use strong user authentication
  - [ ] Create RBAC policies to limit administrator, user, and service account
        activity
- Log auditing
  - [ ] Enable audit logging (disabled by default)

## References

- https://www.nsa.gov/News-Features/Feature-Stories/Article-View/Article/2716980/nsa-cisa-release-kubernetes-hardening-guidance/
- https://media.defense.gov/2021/Aug/03/2002820425/-1/-1/1/CTR_KUBERNETES%20HARDENING%20GUIDANCE.PDF
