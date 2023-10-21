const log = console.log
const fs = require('fs-extra')
const crypto = require('crypto');
const Downloader = require("nodejs-file-downloader");
// Create a hash object

const {
    glob,
    globSync,
    globStream,
    globStreamSync,
    Glob,
} = require('glob');
const { threadId } = require('worker_threads');


//The response object is a node response(http.IncomingMessage)
function onResponse(response) {
    //Now you can do something with the response, like check the headers
    log(response.headers)
    if (response.headers["content-length"] > 1000000) {
      console.log("File is too big!");
      return false; //If you return false, the download process is stopped, and downloader.download() is resolved.
    }
  
    //Returning any other value, including undefined, will tell the downloader to proceed as usual.
  }


async function main(params) {
    log('1')



    // let options = {
    //     directory: "./assets/images/blog/",
    //     filename: '11111.png'
    // }

    // download('https://picsum.photos/id/1052/800/600', options, function (err) {
    //     if (err) throw err
    //     console.log("meow")
    // })





    const dfile = await glob('content/english/posts/*.md', { ignore: 'node_modules/**' })
    // log(dfile)

    
    let arrOfImagesToDw = []
    let y =0
    for (const indMdFile of dfile) {
        log(`Doing ${++y} : ${indMdFile}`)

        let fileContent = fs.readFileSync(indMdFile).toString()
        let arrFileContent = fileContent.split('\n')
        // log(arrFileContent)
        let x = 0
        for (let line of arrFileContent) {
            // log(`line : ${line}`)
            if (line.indexOf('thumbnail') > -1) {
                let oldImgUrl = line.split(' ')[1].trim()
               
                log(`oldImgUrl : ${oldImgUrl}`)

                if(oldImgUrl.indexOf('http')===-1)
                {
                    // throw new Error(`Not URL : ${indMdFile} : ${oldImgUrl}`);
                    console.log(`ERROR [%s]: Not URL : ${indMdFile} : ${oldImgUrl}`)
                    break
                    // process.exit()
                }

                // log(arrOfImagesToDw)
                const sha256Hash = crypto.createHash('md5');
                let newName = `${sha256Hash.update(oldImgUrl, 'utf8').digest('hex')}.png`
                arrOfImagesToDw = [oldImgUrl, newName]
                // log(arrOfImagesToDw)
                // line = `image: "images/${newName}"`
                // process.exit()
                arrFileContent[x] = `image: "images/blog/${newName}"`



                const downloader = new Downloader({
                    url: oldImgUrl,
                    directory: "./assets/images/blog/",
                    fileName: newName, //This will be the file name.
                    cloneFiles: false,
                    onResponse
                    // onBeforeSave: (deducedName) => {
                    //   console.log(`The file name is: ${deducedName}`);
                    //   //If you return a string here, it will be used as the name(that includes the extension!).
                    // },
                  });
            
                  try {
                    await downloader.download();

                    fs.writeFileSync(indMdFile, arrFileContent.join(`\r\n`))
                  } catch (error) {
                    console.log(error);
                  }

                  break

    

            }

            //thumbnail: https://picsum.photos/id/1052/800/600
            //image: "images/blog/03.jpg"
            x++
        }
        // let newFileBody = arrFileContent.join(`\r\n`)
        // log(newFileBody)
        // break
        // // process.exit()
        // log(fileContent)

        // process.exit()
    }


}

main()