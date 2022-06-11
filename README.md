# BUILD YOUR OWN RADAR
> A library that generates an interactive radar, inspired by [thoughtworks.com/radar](http://thoughtworks.com/radar).

## Demo

You can see this in action at https://radar.thoughtworks.com. If you plug in [this data](https://docs.google.com/spreadsheets/d/18A7oDuavlh89rAmqcaXpqle8QLqIvlAkoEUxcObzuUM/edit#gid=1985253373) you'll see [this visualization](https://radar.thoughtworks.com/?sheetId=https%3A%2F%2Fdocs.google.com%2Fspreadsheets%2Fd%2F18A7oDuavlh89rAmqcaXpqle8QLqIvlAkoEUxcObzuUM%2Fedit%23gid%3D1985253373). 

## How To Use

The easiest way to use the app out of the box is to provide a *public* Google Sheet ID from which all the data will be fetched. You can enter that ID into the input field on the first page of the application, and your radar will be generated. The data must conform to the format below for the radar to be generated correctly.

### Setting up your data

You need to make your data public in a form we can digest.

Create a Google Sheet. Give it at least the below column headers, and put in the content that you want:

| name          | ring   | quadrant               | isNew | description                                             |
|---------------|--------|------------------------|-------|---------------------------------------------------------|
| Composer      | adopt  | tools                  | TRUE  | Although the idea of dependency management ...          |
| Canary builds | trial  | techniques             | FALSE | Many projects have external code dependencies ...       |
| Apache Kylin  | assess | platforms              | TRUE  | Apache Kylin is an open source analytics solution ...   |
| JSF           | hold   | languages & frameworks | FALSE | We continue to see teams run into trouble using JSF ... |

### Sharing the sheet

* In Google sheets, go to 'File', choose 'Publish to the web...' and then click 'Publish'.
* Close the 'Publish to the web' dialog.
* Copy the URL of your editable sheet from the browser (Don't worry, this does not share the editable version). 

The URL will be similar to [https://docs.google.com/spreadsheets/d/1waDG0_W3-yNiAaUfxcZhTKvl7AUCgXwQw8mdPjCz86U/edit](https://docs.google.com/spreadsheets/d/1waDG0_W3-yNiAaUfxcZhTKvl7AUCgXwQw8mdPjCz86U/edit). In theory we are only interested in the part between '/d/' and '/edit' but you can use the whole URL if you want.

### Using CSV data
The other way to provide your data is using CSV document format.
You can enter any URL that responds CSV data into the input field on the first page.
The format is just the same as that of the Google Sheet, the example is as follows:

```
name,ring,quadrant,isNew,description  
Composer,adopt,tools,TRUE,"Although the idea of dependency management ..."  
Canary builds,trial,techniques,FALSE,"Many projects have external code dependencies ..."  
Apache Kylin,assess,platforms,TRUE,"Apache Kylin is an open source analytics solution ..."  
JSF,hold,languages & frameworks,FALSE,"We continue to see teams run into trouble using JSF ..."  
```

***Note:*** The CSV file parsing is using D3 library, so consult the D3 documentation for the data format details.

### Building the radar

Paste the URL in the input field on the home page.

That's it!

***Note:*** The quadrants of the radar, and the order of the rings inside the radar will be drawn in the order they appear in your data.

Check [this page](https://www.thoughtworks.com/radar/how-to-byor) for step by step guidance.

### More complex usage

To create the data representation, you can use the Google Sheet [factory](/src/util/factory.js) or CSV, or you can also insert all your data straight into the code.

The app uses [Tabletop.js](https://github.com/jsoma/tabletop) to fetch the data from a Google Sheet or [D3.js](https://d3js.org/) if supplied as CSV, so refer to their documentation for more advanced interaction.  The input data is sanitized by whitelisting HTML tags with [sanitize-html](https://github.com/punkave/sanitize-html).

The application uses [webpack](https://webpack.github.io/) to package dependencies and minify all .js and .scss files.

The application also supports private google sheets. For that you must have created a google service account and credentials associated with it in a token.json file (to create a service account see https://cloud.google.com/iam/docs/creating-managing-service-accounts).


```
export ENABLE_GOOGLE_AUTH=true
export API_KEY=[Google API Key]
export CLIENT_ID=[Google Client ID]
```

## Docker Image
I have released a dev-mode BYOR as a docker image for easy use. The image is available in [DockerHub Repo](https://hub.docker.com/r/alexiscaspell/build-your-own-radar/). To pull and run the image, run the following commands.

```
$ docker pull alexiscaspell/build-your-own-radar
$ docker run --rm -p 8080:8080 -v /path-to-your-token/token.json:/src/build-your-own-radar/token.json alexiscaspell/build-your-own-radar
$ open http://localhost:8080
```
You can check your setup by clicking on "Build my radar" and by loading the `csv` file on this location: http://localhost:8080/sheets/radar.csv

## Advanced option - Docker image served with nginx 

```
$ cp /path-to-your-token/token.json token.json
$ docker build -t build-your-own-radar -f Dockerfile-prod
$ docker run --rm -p 8080:80 build-your-own-radar
$ open http://localhost:8080
```                                                                                                                    

Also in both cases you can always work locally on your machine, updating the csv file (mounting dir /mnt/radar/sheets/) and rendering the result back on your browser.
