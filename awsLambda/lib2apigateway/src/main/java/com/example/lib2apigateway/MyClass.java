package com.example.lib2apigateway;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.HashMap;

public class MyClass implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {
    Gson gson = new GsonBuilder().setPrettyPrinting().create();

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent event, Context context){
        LambdaLogger logger = context.getLogger();

        HashMap<String, String> headers = new HashMap<String, String>();

        headers.put("Content-Type","application/json");
        headers.put("X-Custom-Header","application/json");

        APIGatewayProxyResponseEvent reponse = new APIGatewayProxyResponseEvent();
        reponse.withHeaders(headers);

        // log execution details
        logger.log("Processing request data for request " + event.getRequestContext());
        logger.log("Body size = " + event.getBody().length());
        logger.log("Headers: " + gson.toJson(event.getHeaders()));
        logger.log("Bodys: " + gson.toJson(event.getBody()));

        return reponse;
    }
}