import json
import boto3

# Conectar con DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitas-portfolio')

def lambda_handler(event, context):
    # Actualizar el contador de forma atómica (suma 1 de forma segura)
    response = table.update_item(
        Key={
            'id': 'contador'
        },
        UpdateExpression='ADD cantidad :inc',
        ExpressionAttributeValues={
            ':inc': 1
        },
        ReturnValues="UPDATED_NEW"
    )
    
    # Extraer el nuevo número
    visitas = int(response['Attributes']['cantidad'])
    
    # Devolver respuesta con cabeceras CORS (vital para que la web lo acepte)
    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        'body': json.dumps({'visitas': visitas})
    }