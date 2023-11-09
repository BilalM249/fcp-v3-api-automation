function fn() {

	var env = karate.env;

	if(env == null) {
		env = 'v3_prod';
	}
	// TODO build a map
//	if(env == 'local') {
//		var temp = read('classpath:environment-variables.json');
//		config = temp.local;
//	}
//
//	if(env === 'stg02') {
//		var temp = read('classpath:environment-variables.json');
//		config = temp.stg02;
//	}
//
//	if(env === 'dev02') {
//		var temp = read('classpath:environment-variables.json');
//		config = temp.dev02;
//	}
//
//	if(env === 'sandbox') {
//		var temp = read('classpath:environment-variables.json');
//		config = temp.sandbox;
//	}
//
//	if(env === 'prod') {
//		var temp = read('classpath:environment-variables.json');
//		config = temp.prod;
//	}
	if(env === 'v3_stg02')
	{
	    var temp = read('classpath:environment-variables.json');
    	config = temp.v3_stg02;
	}
	if(env === 'v3_prod')
    	{
    	    var temp = read('classpath:environment-variables.json');
        	config = temp.v3_prod;
    	}

	karate.log("Selected environment is - ", env);
	karate.log(config)

//	// take username and password from command line
//	var username = java.lang.System.getenv('KARATE_USERNAME')
//	var password = java.lang.System.getenv('KARATE_PASSWORD')
//
//	config.username = username;
//	config.password = password;

	// don't waste time waiting for a connection or if servers don't respond within 5 seconds
	karate.configure('connectTimeout', 1000);
	karate.configure('readTimeout', 30000);

	karate.configure('ssl', true);

	// var traceId = java.util.UUID.randomUUID().toString();

	// karate.configure('headers', { 'X-override': '{ "be_i18n": false, "enable_local_refresh_cache": false }', 'X-Trace-Id': 'karate-integration-test-'+traceId });

    if(env === "v3_stg02")
    {
        var generateToken = karate.callSingle('classpath:karate/auth/generateToken.feature', config);
        config.auth = generateToken.response.access_token
        karate.log(config.auth);
    }
    if(env === "v3_prod")
        {
            var generateToken = karate.callSingle('classpath:karate/auth/generateTokenForProd.feature', config);
            config.auth = generateToken.response.access_token
            karate.log(config.auth);
        }






	return config;
}
