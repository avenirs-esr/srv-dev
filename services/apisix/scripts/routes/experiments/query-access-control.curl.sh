TOKEN='eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCIsImtpZCI6ImNhcy1GT1NYenFvWCIsIm9yZy5hcGVyZW8uY2FzLnNlcnZpY2VzLlJlZ2lzdGVyZWRTZXJ2aWNlIjoiNDQwMCJ9.eyJzdWIiOiJhbGxpc29uIiwib2F1dGhDbGllbnRJZCI6Ik9JRENDbGllbnRJZCIsInJvbGVzIjpbXSwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3QvY2FzIiwiY2xpZW50X2lkIjoiT0lEQ0NsaWVudElkIiwiZ3JhbnRfdHlwZSI6Im5vbmUiLCJwZXJtaXNzaW9ucyI6W10sInNjb3BlIjpbIm9wZW5pZCIsInByb2ZpbGUiLCJlbWFpbCJdLCJzZXJ2ZXJJcEFkZHJlc3MiOiIxNzIuMTguMC4yMCIsImxvbmdUZXJtQXV0aGVudGljYXRpb25SZXF1ZXN0VG9rZW5Vc2VkIjpmYWxzZSwic3RhdGUiOiIiLCJleHAiOjE3MjEwNzQ0NjIsImlhdCI6MTcyMTA0NTY2MiwianRpIjoiQVQtMy1PNkQ5MGtXWjMzRVlNWHlaMnNpWm1hZGtqOExCU3luNSIsImVtYWlsIjoiYWxsaXNvbkB1bml2LmZyIiwiY2xpZW50SXBBZGRyZXNzIjoiMTcyLjE4LjAuMSIsImlzRnJvbU5ld0xvZ2luIjp0cnVlLCJhdXRoZW50aWNhdGlvbkRhdGUiOiIyMDI0LTA3LTE1VDEyOjE0OjIyLjU2ODQzMVoiLCJzdWNjZXNzZnVsQXV0aGVudGljYXRpb25IYW5kbGVycyI6IkxkYXBBdXRoZW50aWNhdGlvbkhhbmRsZXIiLCJ1c2VyQWdlbnQiOiJNb3ppbGxhLzUuMCAoWDExOyBMaW51eCB4ODZfNjQ7IHJ2OjEyNy4wKSBHZWNrby8yMDEwMDEwMSBGaXJlZm94LzEyNy4wIiwiZ2l2ZW5fbmFtZSI6IkFMTElTT04gQ2hhcmxvdHRlIiwibm9uY2UiOiIiLCJjcmVkZW50aWFsVHlwZSI6IlVzZXJuYW1lUGFzc3dvcmRDcmVkZW50aWFsIiwic2FtbEF1dGhlbnRpY2F0aW9uU3RhdGVtZW50QXV0aE1ldGhvZCI6InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjEuMDphbTpwYXNzd29yZCIsImF1ZCI6Ik9JRENDbGllbnRJZCIsImF1dGhlbnRpY2F0aW9uTWV0aG9kIjoiTGRhcEF1dGhlbnRpY2F0aW9uSGFuZGxlciIsInNjb3BlcyI6WyJvcGVuaWQiLCJwcm9maWxlIiwiZW1haWwiXSwiZmFtaWx5X25hbWUiOiJBTExJU09OIn0.OqFeXVyeIE0SE2HBB0yr-o64pFeWPzNzf07K9ITpuQNx84W5e7pAvbUPB9w2aKUMliZnj2j4FG-Mox4GaEJa6QbgD9wKjJOvmT1ZL_8358fG1m0pgeeg0v6A3DsGVez4zTN8S6rf4PCN-Fmkef9FAlZ6pB-NWrlFa5IhmPK_CKx75EJsHqA-K2TBGKnVrmXeOVEF8RDb2gjp1VyC5nHfw4jnfzHDAEKijQvK5nM9vOJwTaH3P6ujsfyHAS7XND04m_Vsw8nelxfqhvCBlk0_ffZfcXjFISLs5nByDfUvVLvVyeVrlfLXEjzmDfyieDtLRtfagTfncKkx-q35K1jyxQ'


curl --header "x-authorization: $TOKEN" "http://localhost/apisix-gw/access-control?method=get&uri=/foo&resource=1" -i