Feature: Generate S2S token

  Background:

    * url identity_endpoint

  Scenario: Get Auth Token

    Given path 'oauth2/aus9c1jlr7cmx7eEf696/v1/token'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header accept = 'application/json'
    And header authorization = 'Basic MG9hM2VvcGE4M0RSTHVFU2k2OTc6SHlfZUVLLTZ3Q0dsdFB1MFRibjNqeEotTGRNdlFKSmpsWVJZQ0x6aw=='
    And request 'grant_type=client_credentials&scope=s2s'
    When method post
    Then status 200