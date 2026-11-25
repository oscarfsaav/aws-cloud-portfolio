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

    # CORS lo gestiona API Gateway, por eso aquí solo se devuelve el contenido
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({'visitas': visitas})
    }