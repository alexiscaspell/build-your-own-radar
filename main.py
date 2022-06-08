from google.oauth2 import service_account
from googleapiclient.discovery import build
import csv

def application(env, start_response):

    query_params = env.get("QUERY_PARAMS","").split("&")
    query_params = {q.split("=")[0]:q.split("=")[1] for q in query_params}

    # If modifying these scopes, delete the file token.json.
    SCOPES = ['https://www.googleapis.com/auth/spreadsheets']

    # The ID and range of a sample spreadsheet.
    SAMPLE_SPREADSHEET_ID = query_params["id"]
    SAMPLE_RANGE_NAME = 'A1:E'

    creds = None

    creds = service_account.Credentials.from_service_account_file('/app/token.json', scopes=SCOPES)

    service = build('sheets', 'v4', credentials=creds)

    sheet = service.spreadsheets()
    result = sheet.values().get(spreadsheetId=SAMPLE_SPREADSHEET_ID,range=SAMPLE_RANGE_NAME).execute()

    sheet_name = result.get("range","'Tech-Radar'").split("'")[1]
    # sheet_name = SAMPLE_SPREADSHEET_ID

    with open(f'/opt/build-your-own-radar/sheets/{sheet_name}.csv', 'w', newline='') as file:
        writer = csv.writer(file, delimiter=',')
        writer.writerows(result.get("values",[]))

    start_response("200 OK", [("Content-Type", "text/plain")])

    message=f"{sheet_name}"

    return [message.encode("utf-8")]