-- liyao
-- example script that demonstrates use of setup() to pass
-- data to and from the threads

local counter = 1
local threads = {}

-- 创建线程
function setup(thread)
   thread:set("id", counter)
   table.insert(threads, thread)
   counter = counter + 1
end

-- 初始化请求
function init(args)
   requests  = 0
   responses = 0
   failtimes = 0

   local msg = "thread %d created"
   print(msg:format(id))
end

-- 修改请求参数,测试不同post,不同header,注意此函数的参数 wrk.format(method, path, headers, body)。在文件src/wrk.lua
local posts = require "ly_posts"
function request()
   requests = requests + 1
   local path = "/uri_del"
   local headers = {}
   local body = posts.posts[math.random(1,3)] 
   headers["Host"] = "uri-del.sinaedge.com"
   headers["uriid"] = math.random(0,100)
   if requests%2 == 1 then
        headers["uri-action"] = "recover"
   end
   return wrk.format("POST", path, headers, body)
end

-- 修改请求参数,猜测试不同query
--local query = require "ly_args"
--function request()
--   requests = requests + 1
--   local path = query.args[math.random(0,57)]
--   return wrk.format(nil,path)
--    -- return wrk.request()
--end

-- 读取结果
function response(status, headers, body)
   responses = responses + 1
   if status ~= 200 then 
      failtimes = failtimes + 1
   end
end

-- 所有请求处理完成之后
function done(summary, latency, requests)
   for index, thread in ipairs(threads) do
      local id        = thread:get("id")
      local requests  = thread:get("requests")
      local responses = thread:get("responses")
      local failtimes = thread:get("failtimes")
      local msg = "thread %d made %d requests and got %d responses,and failed %d times( !=200 )"
      print(msg:format(id, requests, responses, failtimes))
   end
end
