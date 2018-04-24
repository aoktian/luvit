local cURL = require("cURL")

local e = cURL.easy{
    url = 'http://10.1.10.50/t.php',
    writefunction = p,
    headerfunction = p
}
e:perform()
