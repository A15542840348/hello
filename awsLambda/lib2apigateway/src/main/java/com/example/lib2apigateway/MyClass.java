package com.example.lib2apigateway;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.model.AttributeDefinition;
import com.amazonaws.services.dynamodbv2.model.KeySchemaElement;
import com.amazonaws.services.dynamodbv2.model.KeyType;
import com.amazonaws.services.dynamodbv2.model.ProvisionedThroughput;
import com.amazonaws.services.dynamodbv2.model.ScalarAttributeType;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.Arrays;
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

        try {
            createTableRemote(logger);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return reponse;
    }

    public static void createTableRemote(LambdaLogger logger) throws Exception{
        AmazonDynamoDB client = AmazonDynamoDBClientBuilder.standard()
                .withRegion(Regions.US_EAST_2)
                .build();

        DynamoDB dynamoDB = new DynamoDB(client);

        String tableName = "Movies";

        try {
            logger.log("Attempting to create table; please wait...");
            Table table = dynamoDB.createTable(tableName,
                    Arrays.asList(new KeySchemaElement("year", KeyType.HASH), // Partition
                            // key
                            new KeySchemaElement("title", KeyType.RANGE)), // Sort key
                    Arrays.asList(new AttributeDefinition("year", ScalarAttributeType.N),
                            new AttributeDefinition("title", ScalarAttributeType.S)),
                    new ProvisionedThroughput(10L, 10L));
            table.waitForActive();
            logger.log("Success.  Table status: " + table.getDescription().getTableStatus());
        }
        catch (Exception e) {
            logger.log("Unable to create table: ");
            logger.log(e.getMessage());
        }
    }
}