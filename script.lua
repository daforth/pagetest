js = require "js"
document = js.global.document
local button = document:getElementById("compile")
local hidebtn = document:getElementById("hide")
local input = document:getElementById("input")
local output = document:getElementById("output")
local example = document:getElementById("example")
function comp()
  output.value = compile(input.value)
end
button:addEventListener("click", comp)

local pipesrc = [[
-- Implementation of the PIPE Buffer

ncel = 6
nsym = 3

--  Basic Cell Agent
proc { LB<C> , ++ 'i:1,nsym' {inn<i> . ~out <i> . LB<C> }}

-- Relabaling for Buffer Out

proc { LB<C,ncel+1>, [ LB<C>, {'i:1,nsym', d<ncel,i> / out<i>} ] }

-- Relabaling for Buffer In
proc { LB<C,0>, [ LB_C, {'i:1,nsym', d<0,i> / inn<i>} ] }

-- Relabaling for Central Cells

proc 'i:1,ncel' {LB<C,i>, [ LB<C>,
                                 {'s:1,nsym', d<i,s> / inn<s> },
                                 {'s:1,nsym', d<i-1,s> / out<s> }
                           ]
                }

-- Put all in parallel

dset { Internals, :: {{'s:1,nsym', 'i:0,ncel', d<i,s>}} }

proc { LB, || 'i:0,ncel+1' {LB<C,i>} \ Internals }]]

example:addEventListener("click", function() input.value = pipesrc end)
local outvis = true
hidebtn:addEventListener("click", function()
                           if outvis then
                             -- output.style.display = 'none'
                             input.style.width = '98%'
                             output.style.width = '98%'
                             hidebtn.textContent = '<'
                             outvis = false
                           else
                             -- output.style.display = 'inline'
                             input.style.width = '49%'
                             output.style.width = '49%'
                             hidebtn.textContent = '>'
                             outvis = true
                           end
end)
