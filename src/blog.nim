import markdown, os, times

when isMainModule:
  include "../web/html.tmpl"
  import cligen

  let
    contentDir = "content"
    markdownFileName = "index.md"

  proc article_add (
    id: string,
    date: string = times.getDateStr()
  ): int =
    discard os.existsOrCreateDir(contentDir)
    let id = date & "-" & id
    os.createDir(contentDir / id)
    block:
      var indexMd = open(contentDir / id / markdownFileName, FileMode.fmWrite)
      defer:
        indexMd.close()
        echo "📝 ", contentDir / id / markdownFileName, " has been generated."

  proc build: int =
    for _, path in walkDir("content"):
      let
        file = open(path, FileMode.fmRead)
        identifyName = path[8..(path.high - 3)]
      var outfile = open("dist/" & identifyName & ".html" ,FileMode.fmWrite)
      let body = file.readAll.markdown
      outfile.writeLine(htmlTmpl(identifyName, body))
      echo "📝 dist/", identifyName, ".html has been generated."

  dispatchMulti(
    [article_add, cmdName = "article-add"],
    [build]
  )