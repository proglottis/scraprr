require 'minitest/autorun'
require 'minitest/mock'
require 'scraprr'

def xml_trivial
  xml = <<-EOF
  <Products>
    <Beers>
      <Beer region="New Zealand">
        <Name>Beer1</Name>
        <Volume>330ml</Volume>
      </Beer>
      <Beer>
        <Name>Beer2</Name>
        <Volume>500ml</Volume>
      </Beer>
      <Beer>
        <Name>  Beer3  </Name>
        <Volume>  440ml  </Volume>
      </Beer>
      <Beer>
        <Name></Name>
        <Volume>375ml</Volume>
      </Beer>
    </Beers>
  </Products>
  EOF
  Nokogiri::XML(xml)
end

def html_composite
  html = <<-EOF
  <html>
    <head></head>
    <body>
      <table>
        <tr><th>Beer</th><th>$</th></tr>
        <tr><td>Beer1 - 5%, 330ml</td><td>10.0<br></td></tr>
        <tr><td>Beer2 - 6%, 500ml</td><td>16.0<br></td></tr>
        <tr><td>Beer3 - 10%, 375ml</td><td>20.0<br></td></tr>
      </table>
    </body>
  </html>
  EOF
  Nokogiri::HTML(html)
end
