function insert_mail_address () {
  // Email obfuscator script 2.1 by Tim Williams, University of Arizona
  // Random encryption key feature by Andrew Moulden, Site Engineering Ltd
  // This code is freeware provided these four comment lines remain intact
  // A wizard to generate this code is at http://www.jottings.com/obfuscator/
  coded = "DsTgn39a1zdgF@J9zaF.ps9"
    key = "4BQoPj2GU97zZRpgbIw1qlCtYOsiDEkvHy0ShnJdu56VFLKMmTa8NceXfWr3Ax"
    shift=coded.length
    link=""
    for (i=0; i<coded.length; i++) {
      if (key.indexOf(coded.charAt(i))==-1) {
        ltr = coded.charAt(i)
          link += (ltr)
      }
      else {     
        ltr = (key.indexOf(coded.charAt(i))-shift+key.length) % key.length
          link += (key.charAt(ltr))
      }
    }
  document.write("<a href='mailto:"+link+"'><img src='/hp/img/googlemail-64.png' width='46' alt='Email me'/></a>")
}
