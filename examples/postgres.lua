local driver = require"luasql.postgres"
local env = driver.postgres()
local conn = env:connect("host = 127.0.0.1 port=5432 user=postgres dbname=xa")
local cur = conn:execute("select * from p_overlook")
while true do
    local row = {}
    cur:fetch(row, "a")
    if not next(row) then break end
    p("----------->fetch", row)
end
