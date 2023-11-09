Feature: Generate S2S token

  Background:

    * url identity_endpoint

  Scenario: Get Auth Token

    Given path 'oauth2/ausopbo9srORwHcM5696/v1/token'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header accept = 'application/json'
    And header authorization = 'Basic MG9hM2V1bXE5c1JBRDRmSnQ2OTc6V2lOeGF6MjZUeWlfbm5JUDd5bWxkcS1fRmhDNGdlWDZhRC1VNFFsNg=='
    And request 'grant_type=client_credentials&scope=s2s'
    When method post
    Then status 200