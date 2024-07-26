local __DARKLUA_BUNDLE_MODULES __DARKLUA_BUNDLE_MODULES={cache={}, load=function(m)if not __DARKLUA_BUNDLE_MODULES.cache[m]then __DARKLUA_BUNDLE_MODULES.cache[m]={c=__DARKLUA_BUNDLE_MODULES[m]()}end return __DARKLUA_BUNDLE_MODULES.cache[m].c end}do function __DARKLUA_BUNDLE_MODULES.a()

return nil end function __DARKLUA_BUNDLE_MODULES.b()

local function all(array,predicate)
for index,element in array do
if not predicate(element,index)then
return false
end
end
return true
end

return all end function __DARKLUA_BUNDLE_MODULES.c()

local function reduce(
array,
reducer,
accumulator
)
if accumulator==nil then
for index,value in array do
if index==1 then
accumulator=value
else
accumulator=reducer(accumulator,value,index)
end
end
else
for index,value in array do
accumulator=reducer(accumulator,value,index)
end
end
return accumulator
end











return(reduce)end function __DARKLUA_BUNDLE_MODULES.d()

local reduce=__DARKLUA_BUNDLE_MODULES.load('c')

local function alternate(array,...)
local alternateWith={...}

if#alternateWith==0 then
return array
end

local minimumLength=reduce(alternateWith,function(minimum,value)
return math.min(minimum,#value)
end,#array)

if minimumLength==0 then
return{}
end

local result={}

for i=1,minimumLength do
table.insert(result,array[i])
for _,otherArray in alternateWith do
table.insert(result,(otherArray[i]))
end
end

return result
end






return(alternate)end function __DARKLUA_BUNDLE_MODULES.e()

local function any(array,predicate)
for index,element in array do
if predicate(element,index)then
return true
end
end
return false
end

return any end function __DARKLUA_BUNDLE_MODULES.f()

local function average(array)
local length=#array
if length==0 then
return nil
end

local result=0

for _,element in array do
result+=element
end

return result/length
end

return average end function __DARKLUA_BUNDLE_MODULES.g()

local function averageBy(array,map)
local length=#array
if length==0 then
return nil
end

local result=0

for _,element in array do
result+=map(element)
end

return result/length
end

return averageBy end function __DARKLUA_BUNDLE_MODULES.h()

local function concat(array,...)
local result=nil

for i=1,select('#',...)do
local concatWith=select(i,...)

if concatWith~=nil and#concatWith>0 then
result=result or table.clone(array)

for _,element in concatWith do
table.insert(result,element)
end
end
end

return result or array
end

return concat end function __DARKLUA_BUNDLE_MODULES.i()

local function contains(array,element)
for _,value in array do
if value==element then
return true
end
end
return false
end

return contains end function __DARKLUA_BUNDLE_MODULES.j()

return table.clone end function __DARKLUA_BUNDLE_MODULES.k()

local function deduplicate(array)
if#array==0 then
return array
end

local removeIndexes={}

local seenSet={}

for index,element in array do
if seenSet[element]==nil then
seenSet[element]=true
else
table.insert(removeIndexes,index)
end
end

local totalIndexes=#removeIndexes
if totalIndexes==0 then
return array
else
local result=table.clone(array)
for i=totalIndexes,1,-1 do
table.remove(result,removeIndexes[i])
end
return result
end
end

return deduplicate end function __DARKLUA_BUNDLE_MODULES.l()

local function deduplicateByKey(array,key)
local removeIndexes={}

local seenSet={}

for index,element in array do
local elementKey=key(element)
if seenSet[elementKey]==nil then
seenSet[elementKey]=true
else
table.insert(removeIndexes,index)
end
end

local totalIndexes=#removeIndexes
if totalIndexes==0 then
return array
else
local result=table.clone(array)
for i=totalIndexes,1,-1 do
table.remove(result,removeIndexes[i])
end
return result
end
end

return deduplicateByKey end function __DARKLUA_BUNDLE_MODULES.m()

local function filter(array,predicate)
local new={}
for i,element in array do
if predicate(element,i)then
table.insert(new,element)
end
end
return new
end

return filter end function __DARKLUA_BUNDLE_MODULES.n()

local function find(
array,
predicate,
start
)
if start==nil or start==1 then
for index,element in array do
if predicate(element,index)then
return element
end
end
else
local length=#array
for i=start,length do
local element=array[i]
if predicate(element,i)then
return element
end
end
end

return nil
end

return find end function __DARKLUA_BUNDLE_MODULES.o()

local function findIndex(
array,
predicate,
start
)
if start==nil or start==1 then
for index,element in array do
if predicate(element,index)then
return index
end
end
else
local length=#array
for i=start,length do
local element=array[i]
if predicate(element,i)then
return i
end
end
end

return nil
end

return findIndex end function __DARKLUA_BUNDLE_MODULES.p()

local function findIndexByValue(array,element,start)
return table.find(array,element,start)
end

return findIndexByValue end function __DARKLUA_BUNDLE_MODULES.q()

local function findMap(array,mapFn,start)
if start==nil or start==1 then
for index,element in array do
local result=mapFn(element,index)
if result~=nil then
return result
end
end
else
local length=#array
for i=start,length do
local element=array[i]
local result=mapFn(element,i)
if result~=nil then
return result
end
end
end

return nil
end

return findMap end function __DARKLUA_BUNDLE_MODULES.r()

local function isArray(value)
if type(value)~='table'then
return false
end

local tableValue=value

if next(tableValue)==nil then

return true
end

local length=#tableValue

if length==0 then
return false
end

local expectIndex=0

for key in tableValue do
expectIndex+=1
if type(key)~='number'or key~=expectIndex then
return false
end
end

return length==expectIndex
end

return isArray end function __DARKLUA_BUNDLE_MODULES.s()

local isArray=__DARKLUA_BUNDLE_MODULES.load('r')

local function flatMap(array,mapFn)
local new={}
for i,element in array do
local value=mapFn(element,i)
if value~=nil then
if isArray(value)then
for _,innerElement in value do
table.insert(new,innerElement)
end
else
table.insert(new,value)
end
end
end
return new
end

return flatMap end function __DARKLUA_BUNDLE_MODULES.t()

local isArray=__DARKLUA_BUNDLE_MODULES.load('r')

local function flatten(array,depth)
local actualDepth=if depth==nil then math.huge else depth
if actualDepth==0 then
return array
end

local new={}

for _,element in array do
if isArray(element)then
local iter=if actualDepth>1
then flatten(element)
else element
for _,innerElement in iter do
table.insert(new,innerElement)
end
else
table.insert(new,element)
end
end

return new
end

return flatten end function __DARKLUA_BUNDLE_MODULES.u()

local function fromFn(generator)
local array={}

local i=1
while true do
local element=generator(i)
if element==nil then
break
else
i+=1
table.insert(array,element)
end
end

return array
end

return fromFn end function __DARKLUA_BUNDLE_MODULES.v()

local function fromTryFn(generator)
local array={}

local i=1
while true do
local success,element=pcall(generator,i)
if success==false or element==nil then
break
else
i+=1
table.insert(array,element)
end
end

return array
end

return fromTryFn end function __DARKLUA_BUNDLE_MODULES.w()

local function isEmpty(value)
return next(value)==nil
end

return isEmpty end function __DARKLUA_BUNDLE_MODULES.x()

local function map(array,mapFn)
local new={}
for i,element in array do
local value=mapFn(element,i)
if value~=nil then
table.insert(new,value)
end
end
return new
end

return map end function __DARKLUA_BUNDLE_MODULES.y()

local function maximum(array,initialValue)
if initialValue==nil then
if#array==0 then
error('initial value must be provided to Array.maximum when the array is empty')
end
initialValue=array[1]
end

local accumulator=initialValue
for _,element in array do
accumulator=math.max(accumulator,element)
end
return accumulator
end

return maximum end function __DARKLUA_BUNDLE_MODULES.z()

local function maximumBy(array,map,initialValue)
if initialValue==nil then
if#array==0 then
error('initial value must be provided to Array.maximumBy when the array is empty')
end
initialValue=map(array[1])
end

local accumulator=initialValue
for _,element in array do
accumulator=math.max(accumulator,map(element))
end
return accumulator
end

return maximumBy end function __DARKLUA_BUNDLE_MODULES.A()

local function minimum(array,initialValue)
if initialValue==nil then
if#array==0 then
error('initial value must be provided to Array.minimum when the array is empty')
end
initialValue=array[1]
end

local accumulator=initialValue
for _,element in array do
accumulator=math.min(accumulator,element)
end
return accumulator
end

return minimum end function __DARKLUA_BUNDLE_MODULES.B()

local function minimumBy(array,map,initialValue)
if initialValue==nil then
if#array==0 then
error('initial value must be provided to Array.minimumBy when the array is empty')
end
initialValue=map(array[1])
end

local accumulator=initialValue
for _,element in array do
accumulator=math.min(accumulator,map(element))
end
return accumulator
end

return minimumBy end function __DARKLUA_BUNDLE_MODULES.C()

local function partition(array,predicate)
local trueValues={}
local falseValues={}
for i,element in array do
if predicate(element,i)then
table.insert(trueValues,element)
else
table.insert(falseValues,element)
end
end
return trueValues,falseValues
end

return partition end function __DARKLUA_BUNDLE_MODULES.D()

local function pop(array,count)
local actualCount=count or 1

if actualCount==1 then
local new=table.clone(array)
table.remove(new)
return new
elseif actualCount==0 then
return array
else
local length=#array

local remaining=length-actualCount

if remaining<=0 then
return{}
elseif remaining>actualCount then
local new=table.clone(array)

for _=1,actualCount do
table.remove(new)
end

return new
else
local new={}

for i=1,remaining do
new[i]=array[i]
end
return new
end
end
end

return pop end function __DARKLUA_BUNDLE_MODULES.E()

local function popFirst(array,count)
local actualCount=count or 1

if actualCount==1 then
local new=table.clone(array)
table.remove(new,1)
return new
elseif actualCount==0 then
return array
else
local length=#array

local remaining=length-actualCount

if remaining<=0 then
return{}
elseif remaining>actualCount then
local new=table.clone(array)

for _=1,actualCount do
table.remove(new,1)
end

return new
else
local new={}

for i=1+actualCount,length do
table.insert(new,array[i])
end

return new
end
end
end

return popFirst end function __DARKLUA_BUNDLE_MODULES.F()

local function product(array,initialValue)
local result=if initialValue==nil then 1 else initialValue

for _,element in array do
result*=element
end

return result
end

return product end function __DARKLUA_BUNDLE_MODULES.G()

local function productBy(array,map,initialValue)
local result=if initialValue==nil then 1 else initialValue

for _,element in array do
result*=map(element)
end

return result
end

return productBy end function __DARKLUA_BUNDLE_MODULES.H()

local function push(array,...)
local newArray=table.clone(array)

for i=1,select('#',...)do
local element=select(i,...)
if element~=nil then
table.insert(newArray,element)
end
end

return newArray
end

return push end function __DARKLUA_BUNDLE_MODULES.I()

local function range(array,from,to)
local length=#array
if length==0 then
return array
end
local actualTo=if to==nil then length else to

local normalizedFrom=if from<0 then 1+(from+length)else from
local normalizedTo=if actualTo<0 then 1+(actualTo+length)else actualTo

local result={}

if normalizedTo>=normalizedFrom then
for i=math.max(normalizedFrom,1),math.min(normalizedTo,length)do
table.insert(result,array[i])
end
else
for i=math.min(normalizedFrom,length),math.max(normalizedTo,1),-1 do
table.insert(result,array[i])
end
end

return result
end

return range end function __DARKLUA_BUNDLE_MODULES.J()

local function removeSortedIndexes(array,indexes)
local removeLength=#indexes
local arrayLenth=#array

if removeLength==0 or arrayLenth==0 then
return array
end

local startFrom=nil
for i=removeLength,1,-1 do
local index=indexes[i]
if index<=arrayLenth then
startFrom=index
break
end
end

if startFrom==nil then
return array
else
local cloned=table.clone(array)
local length=arrayLenth

local previous=nil
for i=startFrom,1,-1 do
local index=indexes[i]
if index~=previous and index<=length then
length-=1
table.remove(cloned,index)
previous=index
end
end

return cloned
end
end

return removeSortedIndexes end function __DARKLUA_BUNDLE_MODULES.K()

local function sort(array,comparator)
if#array<=1 then
return array
end
local result=table.clone(array)
table.sort(result,comparator)
return result
end

return sort end function __DARKLUA_BUNDLE_MODULES.L()

local removeSortedIndexes=__DARKLUA_BUNDLE_MODULES.load('J')
local sort=__DARKLUA_BUNDLE_MODULES.load('K')

local function removeIndexes(array,indexes)
local removeLength=#indexes
local arrayLenth=#array

if removeLength==0 or arrayLenth==0 then
return array
end

local sortedIndexes=sort(indexes)

return removeSortedIndexes(array,sortedIndexes)
end

return removeIndexes end function __DARKLUA_BUNDLE_MODULES.M()

local function removeValues(array,...)
local removeLength=select('#',...)
local arrayLenth=#array

if removeLength==0 or arrayLenth==0 then
return array
end

local removeIndexes={}
for index,element in array do
for i=1,removeLength do
local value=select(i,...)

if value~=nil and element==value then
table.insert(removeIndexes,index)
end
end
end

local removeIndexesLength=#removeIndexes

if removeIndexesLength==0 then
return array
elseif removeIndexesLength==arrayLenth then
return{}
else
local cloned=table.clone(array)

for i=removeIndexesLength,1,-1 do
table.remove(cloned,removeIndexes[i])
end

return cloned
end
end

return removeValues end function __DARKLUA_BUNDLE_MODULES.N()

local function reverse(array)
local length=#array

if length<2 then
return array
end

local newArray=table.clone(array)

for i=1,math.floor(length/2)do
local swapRight=length-i+1

newArray[i],newArray[swapRight]=newArray[swapRight],newArray[i]
end

return newArray
end

return reverse end function __DARKLUA_BUNDLE_MODULES.O()

local map=__DARKLUA_BUNDLE_MODULES.load('x')



local function sortByKey(array,key)
if#array<=1 then
return array
end
local result=map(array,function(element)
return{
key=key(element),
element=element,
}
end)

table.sort(result,function(a,b)
return a.key<b.key
end)

for index,element in result do
result[index]=(element.element)
end

return result
end

return sortByKey end function __DARKLUA_BUNDLE_MODULES.P()

local function stepBy(array,step)
local length=#array

if step==1 then
return array
elseif step==-1 then
local newArray=table.clone(array)

for i=1,math.floor(length/2)do
local swapRight=length-i+1

newArray[i],newArray[swapRight]=newArray[swapRight],newArray[i]
end

return newArray
elseif step>1 then
local result={}

for i=1,length,step do
table.insert(result,array[i])
end

return result
elseif step<-1 then
local result={}

for i=length,1,step do
table.insert(result,array[i])
end

return result
else
error(`invalid step value '{step}' passed to Array.stepBy`)
end
end

return stepBy end function __DARKLUA_BUNDLE_MODULES.Q()

local function sum(array,initialValue)
local result=if initialValue==nil then 0 else initialValue

for _,element in array do
result+=element
end

return result
end

return sum end function __DARKLUA_BUNDLE_MODULES.R()

local function sumBy(array,map,initialValue)
local result=if initialValue==nil then 0 else initialValue

for _,element in array do
result+=map(element)
end

return result
end

return sumBy end function __DARKLUA_BUNDLE_MODULES.S()

local function takeWhile(
array,
predicate,
start
)
local arrayLength=#array

if arrayLength==0 then
return array
end

local bound=arrayLength+1
local actualStart=if start==nil then 1 else start
if actualStart==1 then
for index,element in array do
if not predicate(element,index)then
bound=index
break
end
end
else
local length=#array
for i=actualStart,length do
local element=array[i]
if not predicate(element,i)then
bound=i
break
end
end
end

if actualStart==bound then
return{}
elseif actualStart==1 and bound>arrayLength then
return array
end

local toInsert=bound-actualStart

if actualStart==1 and toInsert<arrayLength/2 then
local result=table.clone(array)

for _=1,arrayLength-bound do
table.remove(result)
end

return result
else
local result={}

for i=actualStart,bound-1 do
table.insert(result,array[i])
end

return result
end
end

return takeWhile end function __DARKLUA_BUNDLE_MODULES.T()

local reduce=__DARKLUA_BUNDLE_MODULES.load('c')

local function zip(array,...)
local alternateWith={...}

local minimumLength=reduce(alternateWith,function(minimum,value)
return math.min(minimum,#value)
end,#array)

if minimumLength==0 then
return{}
end

local result={}

for i=1,minimumLength do
local entry={array[i]}
for _,otherArray in alternateWith do
table.insert(entry,otherArray[i])
end
table.insert(result,entry)
end

return result
end






return(zip)end function __DARKLUA_BUNDLE_MODULES.U()

return table.clone end function __DARKLUA_BUNDLE_MODULES.V()

local function count(map)
local length=0
for _ in map do
length+=1
end
return length
end

return count end function __DARKLUA_BUNDLE_MODULES.W()

local function entries(map,keyIndex,valueIndex)
local useKeyIndex=if keyIndex==nil then 1 else keyIndex
local useValueIndex=if valueIndex==nil then useKeyIndex+1 else valueIndex

local array={}

for key,value in map do
table.insert(array,{
[useKeyIndex]=key,
[useValueIndex]=value,
})
end

return array
end





return entries end function __DARKLUA_BUNDLE_MODULES.X()

local function invert(map)
if next(map)==nil then
return map
end

local result={}
for key,value in map do
result[value]=key
end
return result
end

return invert end function __DARKLUA_BUNDLE_MODULES.Y()

local function isEmpty(value)
return next(value)==nil
end

return isEmpty end function __DARKLUA_BUNDLE_MODULES.Z()

local function keys(map)
local result={}
for key in map do
table.insert(result,key)
end
return result
end

return keys end function __DARKLUA_BUNDLE_MODULES._()

local function mapEntries(map,mapFn)
local result={}

for key,value in map do
local newKey,newValue=mapFn(key,value)
if newKey~=nil and newValue~=nil then
result[newKey]=newValue
end
end

return result
end

return mapEntries end function __DARKLUA_BUNDLE_MODULES.aa()

local None=table.freeze(setmetatable({},{
__index=function()
error('attempt to index on None symbol')
end,
__tostring=function()
return'<None>'
end,
}))

return None end function __DARKLUA_BUNDLE_MODULES.ab()

local None=__DARKLUA_BUNDLE_MODULES.load('aa')

local function mapValues(map,mapFn)
local result={}

for key,value in map do
local newValue=mapFn(value,key)
if newValue~=nil and newValue~=(None)then
result[key]=newValue
end
end

return result
end

return mapValues end function __DARKLUA_BUNDLE_MODULES.ac()

local None=__DARKLUA_BUNDLE_MODULES.load('aa')

local function merge(...)
local first=nil
local firstIndex=nil
local length=select('#',...)

for i=1,length do
local mergeMap=select(i,...)

if mergeMap~=nil then
firstIndex=i
first=mergeMap
break
end
end

if first==nil then
error('attempt to merge only nil values')
end

if firstIndex==length then
return first
end

local result=nil

for i=firstIndex+1,length do
local mergeMap=select(i,...)

if mergeMap~=nil then
if result==nil then
result=table.clone(first)
setmetatable(result,nil)
end

local metatable=getmetatable(mergeMap)

if metatable~=nil and type(metatable.__call)=='function'then
for key,value in pairs(mergeMap)do
if value==None then
result[key]=nil
else
result[key]=value
end
end
else
for key,value in mergeMap do
if value==None then
result[key]=nil
else
result[key]=value
end
end
end
end
end

return result or first
end








return(merge)end function __DARKLUA_BUNDLE_MODULES.ad()

local isEmpty=__DARKLUA_BUNDLE_MODULES.load('Y')

local function remove(map,...)
local removeLength=select('#',...)

if removeLength==0 or isEmpty(map)then
return map
else
local result=nil

for i=1,removeLength do
local key=select(i,...)

if key~=nil and map[key]~=nil then
result=result or table.clone(map)
result[key]=nil
end
end

return result or map
end
end

return remove end function __DARKLUA_BUNDLE_MODULES.ae()

local function values(map)
local result={}
for _,value in map do
table.insert(result,value)
end
return result
end

return values end function __DARKLUA_BUNDLE_MODULES.af()

local type=__DARKLUA_BUNDLE_MODULES.load('a')



local function fromArray(array)
local set={}
for _,element in array do
set[element]=true
end
return set
end

return fromArray end function __DARKLUA_BUNDLE_MODULES.ag()

local WEAK_KEYS_METATABLE={__mode='k'}

local function WeakMap(default)
local value=default or{}
return(setmetatable(value,WEAK_KEYS_METATABLE))
end

return WeakMap end function __DARKLUA_BUNDLE_MODULES.ah()

local setType=__DARKLUA_BUNDLE_MODULES.load('a')



local Disk={
Array={
all=__DARKLUA_BUNDLE_MODULES.load('b'),
alternate=__DARKLUA_BUNDLE_MODULES.load('d'),
any=__DARKLUA_BUNDLE_MODULES.load('e'),
average=__DARKLUA_BUNDLE_MODULES.load('f'),
averageBy=__DARKLUA_BUNDLE_MODULES.load('g'),
concat=__DARKLUA_BUNDLE_MODULES.load('h'),
contains=__DARKLUA_BUNDLE_MODULES.load('i'),
copy=__DARKLUA_BUNDLE_MODULES.load('j'),
deduplicate=__DARKLUA_BUNDLE_MODULES.load('k'),
deduplicateByKey=__DARKLUA_BUNDLE_MODULES.load('l'),
filter=__DARKLUA_BUNDLE_MODULES.load('m'),
find=__DARKLUA_BUNDLE_MODULES.load('n'),
findIndex=__DARKLUA_BUNDLE_MODULES.load('o'),
findIndexByValue=__DARKLUA_BUNDLE_MODULES.load('p'),
findMap=__DARKLUA_BUNDLE_MODULES.load('q'),
flatMap=__DARKLUA_BUNDLE_MODULES.load('s'),
flatten=__DARKLUA_BUNDLE_MODULES.load('t'),
fromFn=__DARKLUA_BUNDLE_MODULES.load('u'),
fromTryFn=__DARKLUA_BUNDLE_MODULES.load('v'),
isArray=__DARKLUA_BUNDLE_MODULES.load('r'),
isEmpty=__DARKLUA_BUNDLE_MODULES.load('w'),
map=__DARKLUA_BUNDLE_MODULES.load('x'),
maximum=__DARKLUA_BUNDLE_MODULES.load('y'),
maximumBy=__DARKLUA_BUNDLE_MODULES.load('z'),
minimum=__DARKLUA_BUNDLE_MODULES.load('A'),
minimumBy=__DARKLUA_BUNDLE_MODULES.load('B'),
partition=__DARKLUA_BUNDLE_MODULES.load('C'),
pop=__DARKLUA_BUNDLE_MODULES.load('D'),
popFirst=__DARKLUA_BUNDLE_MODULES.load('E'),
product=__DARKLUA_BUNDLE_MODULES.load('F'),
productBy=__DARKLUA_BUNDLE_MODULES.load('G'),
push=__DARKLUA_BUNDLE_MODULES.load('H'),
range=__DARKLUA_BUNDLE_MODULES.load('I'),
reduce=__DARKLUA_BUNDLE_MODULES.load('c'),
removeIndexes=__DARKLUA_BUNDLE_MODULES.load('L'),
removeSortedIndexes=__DARKLUA_BUNDLE_MODULES.load('J'),
removeValues=__DARKLUA_BUNDLE_MODULES.load('M'),
reverse=__DARKLUA_BUNDLE_MODULES.load('N'),
reversed=__DARKLUA_BUNDLE_MODULES.load('N'),
sort=__DARKLUA_BUNDLE_MODULES.load('K'),
sortByKey=__DARKLUA_BUNDLE_MODULES.load('O'),
stepBy=__DARKLUA_BUNDLE_MODULES.load('P'),
sum=__DARKLUA_BUNDLE_MODULES.load('Q'),
sumBy=__DARKLUA_BUNDLE_MODULES.load('R'),
takeWhile=__DARKLUA_BUNDLE_MODULES.load('S'),
zip=__DARKLUA_BUNDLE_MODULES.load('T'),
},
Map={
copy=__DARKLUA_BUNDLE_MODULES.load('U'),
count=__DARKLUA_BUNDLE_MODULES.load('V'),
entries=__DARKLUA_BUNDLE_MODULES.load('W'),
invert=__DARKLUA_BUNDLE_MODULES.load('X'),
isEmpty=__DARKLUA_BUNDLE_MODULES.load('Y'),
keys=__DARKLUA_BUNDLE_MODULES.load('Z'),
mapEntries=__DARKLUA_BUNDLE_MODULES.load('_'),
mapValues=__DARKLUA_BUNDLE_MODULES.load('ab'),
merge=__DARKLUA_BUNDLE_MODULES.load('ac'),
remove=__DARKLUA_BUNDLE_MODULES.load('ad'),
values=__DARKLUA_BUNDLE_MODULES.load('ae'),
},
Set={
fromArray=__DARKLUA_BUNDLE_MODULES.load('af'),
},
None=__DARKLUA_BUNDLE_MODULES.load('aa'),
WeakMap=__DARKLUA_BUNDLE_MODULES.load('ag'),
}

return Disk end function __DARKLUA_BUNDLE_MODULES.ai()

local module=__DARKLUA_BUNDLE_MODULES.load('ah')

return module end function __DARKLUA_BUNDLE_MODULES.aj()




























local Prefix={}
local PrefixMetatable={
__index=Prefix,
__eq=function(self,other)
return self:equal(other)
end,
}

local function new(self)
return(setmetatable(self,PrefixMetatable))
end

function Prefix.Verbatim(value)
return new({type='Verbatim',value=value})
end

function Prefix.VerbatimUNC(hostName,shareName)
return new({type='VerbatimUNC',hostName=hostName,shareName=shareName})
end

function Prefix.VerbatimDisk(value)
return new({type='VerbatimDisk',value=value})
end

function Prefix.DeviceNS(value)
return new({type='DeviceNS',value=value})
end

function Prefix.UNC(hostName,shareName)
return new({type='UNC',hostName=hostName,shareName=shareName})
end

function Prefix.Disk(value)
return new({type='Disk',value=value})
end

function Prefix.len(self)
local selfType=self.type
if selfType=='Verbatim'then
return 4+string.len((self).value)
elseif selfType=='VerbatimUNC'then
local data=self
local shareNameLen=string.len(data.shareName)
return 8+string.len(data.hostName)+if shareNameLen>0 then 1+shareNameLen else 0
elseif selfType=='VerbatimDisk'then
return 6
elseif selfType=='UNC'then
local data=self
local shareNameLen=string.len(data.shareName)
return 2+string.len(data.hostName)+if shareNameLen>0 then 1+shareNameLen else 0
elseif selfType=='DeviceNS'then
return 4+string.len((self).value)
elseif selfType=='Disk'then
return 2


end
return 0
end

function Prefix.isVerbatim(self)
local selfType=self.type
return selfType=='Verbatim'or selfType=='VerbatimDisk'or selfType=='VerbatimUNC'
end

function Prefix.isDrive(self)
return self.type=='Disk'
end

function Prefix.hasImplicitRoot(self)
return self.type~='Disk'
end

function Prefix.clone(self)
local self=table.clone(self)

return(setmetatable(self,PrefixMetatable))
end

function Prefix.equal(self,other)
local selfType=self.type

if selfType~=other.type then
return false
end

if selfType=='Verbatim'then
return(self).value==(other).value
end
if selfType=='VerbatimUNC'then
return(self).hostName==(other).hostName
and(self).shareName==(other).shareName
end
if selfType=='VerbatimDisk'then
return(self).value==(other).value
end
if selfType=='DeviceNS'then
return(self).value==(other).value
end
if selfType=='UNC'then
return(self).hostName==(other).hostName
and(self).shareName==(other).shareName
end
if selfType=='Disk'then
return(self).value==(other).value
end

return true
end

return Prefix end function __DARKLUA_BUNDLE_MODULES.ak()


















local PrefixParserSlice={}
local PrefixParserSliceMetatable={
__index=PrefixParserSlice,
}

function PrefixParserSlice.new(path,prefix)
local self={
_path=path,
_prefix=prefix,
_index=1,
}

return(setmetatable(self,PrefixParserSliceMetatable))
end

function PrefixParserSlice.stripPrefix(self,prefix)
local self=self

local prefixLength=#prefix
if string.sub(self._prefix,self._index,self._index+prefixLength-1)==prefix then
local self={
_path=self._path,
_prefix=self._prefix,
_index=self._index+prefixLength,
}

return(setmetatable(self,PrefixParserSliceMetatable))
end
return nil
end

function PrefixParserSlice.prefixBytes(self)
local self=self

return string.sub(self._path,1,self._index)
end

function PrefixParserSlice.finish(self)
local self=self

return string.sub(self._path,self._index)
end

return PrefixParserSlice end function __DARKLUA_BUNDLE_MODULES.al()

local PrefixParserSlice=__DARKLUA_BUNDLE_MODULES.load('ak')



















local PrefixParser={}
local PrefixParserMetatable={
__index=PrefixParser,
}

function PrefixParser.new(path,length)
local self={
_path=path,
_prefix=PrefixParser.getPrefix(path,length),
_length=length,
}

return(setmetatable(self,PrefixParserMetatable))
end

function PrefixParser.getPrefix(path,length)
local prefix=string.gsub(string.sub(path,1,length),'/','\\')
return prefix
end

function PrefixParser.asSlice(self)
local self=self

return PrefixParserSlice.new(self._path,string.sub(self._prefix,1,math.min(#self._path,8)))
end

return PrefixParser end function __DARKLUA_BUNDLE_MODULES.am()



local Prefix=__DARKLUA_BUNDLE_MODULES.load('aj')
local PrefixParser=__DARKLUA_BUNDLE_MODULES.load('al')




local function isValidDriveLetter(char)
local charByte=string.byte(char)
return(charByte>=65 and charByte<=90)or(charByte>=97 and charByte<=122)
end

local function parseDrive(path)
local drive=string.sub(path,1,1)

if drive~=''and isValidDriveLetter(drive)and string.sub(path,2,2)==':'then
return string.upper(drive)
end

return nil
end

local function parseDriveExact(path)
local thirdChar=string.sub(path,3,3)
if thirdChar=='/'or thirdChar=='\\'then
return parseDrive(path)
else
return nil
end
end

local function findSepByte(content)
local slash=string.find(content,'/',1,true)
local backSlash=string.find(content,'\\',1,true)

if slash and backSlash then
return math.min(slash,backSlash)
end

return slash or backSlash
end

local function findVerbatimSep(content)
local index=string.find(content,'\\',1,true)
return index
end

local function parseNextComponent(path,verbatim)

local findSeparator=if verbatim then findVerbatimSep else findSepByte

local separatorStart=findSeparator(path)

if separatorStart then
local separatorEnd=separatorStart+1

local component=string.sub(path,1,separatorStart-1)



local path=string.sub(path,separatorEnd)





return component,path
else
return path,''
end
end

local function parsePrefix(path)
local parser=PrefixParser.new(path,8)
local parser=parser:asSlice()

local parser=parser:stripPrefix([[\\]])

if parser then




local nextParser=parser:stripPrefix([[?\]])

if nextParser and string.find(nextParser:prefixBytes(),'/',1,true)==nil then

local uncParser=nextParser:stripPrefix([[UNC\]])
if uncParser then


local path=uncParser:finish()
local server,path=parseNextComponent(path,true)
local share,_=parseNextComponent(path,true)

return Prefix.VerbatimUNC(server,share)
else
local path=nextParser:finish()


local drive=parseDriveExact(path)
if drive then

return Prefix.VerbatimDisk(drive)
else

local prefix=parseNextComponent(path,true)
return Prefix.Verbatim(prefix)
end
end
end

local nextParser=parser:stripPrefix([[.\]])

if nextParser then

local path=nextParser:finish()
local prefix,_=parseNextComponent(path,false)
return Prefix.DeviceNS(prefix)
end

local path=parser:finish()
local server,path=parseNextComponent(path,false)
local share,_=parseNextComponent(path,false)

if server~=''and share~=''then
return Prefix.UNC(server,share)
else

return nil
end
else


local drive=parseDrive(path)
return drive and Prefix.Disk(drive)
end
end

return parsePrefix end function __DARKLUA_BUNDLE_MODULES.an()

local Prefix=__DARKLUA_BUNDLE_MODULES.load('aj')
local parsePrefixWindows=__DARKLUA_BUNDLE_MODULES.load('am')



local MAIN_SEPARATOR_STR=if _G.SYS_PATH_SEPARATOR=='\\'
or _G.SYS_PATH_SEPARATOR=='/'
then _G.SYS_PATH_SEPARATOR

else'/'

local IS_WINDOWS=MAIN_SEPARATOR_STR=='\\'

local function isSepByteUnix(b)
return b=='/'
end

local function isSepByteWindows(b)
return b=='/'or b=='\\'
end

local function isVerbatimSepUnix(b)
return b=='/'
end

local function isVerbatimSepWindows(b)
return b=='\\'
end

local isSepByte=if IS_WINDOWS then isSepByteWindows else isSepByteUnix
local isVerbatimSep=if IS_WINDOWS
then isVerbatimSepWindows
else isVerbatimSepUnix

local function parsePrefixUnix(_path)
return nil
end

local parsePrefix=if IS_WINDOWS
then parsePrefixWindows
else parsePrefixUnix

return{
MAIN_SEPARATOR_STR=MAIN_SEPARATOR_STR,
isSepByte=isSepByte,
isVerbatimSep=isVerbatimSep,
parsePrefix=parsePrefix,
}end function __DARKLUA_BUNDLE_MODULES.ao()

local Prefix=__DARKLUA_BUNDLE_MODULES.load('aj')
local sysPath=__DARKLUA_BUNDLE_MODULES.load('an')

local MAIN_SEPARATOR_STR=sysPath.MAIN_SEPARATOR_STR
































local Component={}
local ComponentMetatable={
__index=Component,
__tostring=function(self)
return self:toString()
end,
__eq=function(self,other)
return self:equal(other)
end,
}

function Component.normal(value)
local self={type='normal',value=value}

return(setmetatable(self,ComponentMetatable))
end

function Component.rootDir()
local self={type='rootDir'}

return(setmetatable(self,ComponentMetatable))
end

function Component.curDir()
local self={type='curDir'}

return(setmetatable(self,ComponentMetatable))
end

function Component.parentDir()
local self={type='parentDir'}

return(setmetatable(self,ComponentMetatable))
end

function Component.prefix(raw,prefix)
local self={type='prefix',raw=raw,parsed=prefix}

return(setmetatable(self,ComponentMetatable))
end

function Component.toString(self)
local componentType=self.type
return if componentType=='normal'
then(self).value
elseif componentType=='curDir'then'.'
elseif componentType=='parentDir'then'..'
elseif componentType=='rootDir'then MAIN_SEPARATOR_STR
else(self).raw
end

function Component.equal(self,other)
local selfType=self.type

if selfType~=other.type then
return false
end

if selfType=='normal'then
return(self).value
==(other).value
elseif selfType=='prefix'then
return(self).parsed:equal(
(other).parsed
)
end

return true
end

return Component end function __DARKLUA_BUNDLE_MODULES.ap()

local Disk=__DARKLUA_BUNDLE_MODULES.load('ai')

local Array=Disk.Array



































local Rev={}
local RevMetatable={
__index=Rev,
__iter=function(self)
local items=self:collect()
return next,items
end,
}

function Rev.new(iter)
local self={
_iter=iter,
}

return(setmetatable(self,RevMetatable))
end

function Rev.next(self)
local self=self

return self._iter:nextBack()
end

function Rev.collect(self)
local self=self

return Array.fromFn(function()
return self:next()
end)
end

function Rev.nextBack(self)
local self=self

return self._iter:next()
end

function Rev.clone(self)
local self=self

return Rev.new(self._iter:clone())
end

return Rev end function __DARKLUA_BUNDLE_MODULES.aq()

local Disk=__DARKLUA_BUNDLE_MODULES.load('ai')

local Component=__DARKLUA_BUNDLE_MODULES.load('ao')
local Prefix=__DARKLUA_BUNDLE_MODULES.load('aj')
local Rev=__DARKLUA_BUNDLE_MODULES.load('ap')
local sysPath=__DARKLUA_BUNDLE_MODULES.load('an')

local isSepByte=sysPath.isSepByte
local isVerbatimSep=sysPath.isVerbatimSep





local Array=Disk.Array










































local function getStateValue(state)
if state=='Done'then
return 3
elseif state=='StartDir'then
return 1
elseif state=='Prefix'then
return 0
else
return 2
end
end






















local Components={}
local ComponentsMetatable={
__index=Components,
__iter=function(self)
local items=self:collect()
return next,items
end,
}

function Components.new(path,prefix,hasPhysicalRoot)
local self={
_path=path,
prefix=prefix,
_hasPhysicalRoot=hasPhysicalRoot,
_front='Prefix',
_back='Body',
}

return(setmetatable(self,ComponentsMetatable))
end

function Components.is(value)
return type(value)=='table'and getmetatable(value)==ComponentsMetatable
end

function Components.prefixLen(self)
local self=self

local prefix=self.prefix
return if prefix then prefix:len()else 0
end

function Components.prefixVerbatim(self)
local self=self

local prefix=self.prefix
return if prefix then prefix:isVerbatim()else false
end


function Components.prefixRemaining(self)
local self=self

local front=self._front
return if front=='Prefix'then self:prefixLen()else 0
end


function Components.lenBeforeBody(self)
local self=self

local front=self._front
local isBeforeStartDir=getStateValue(front)<=getStateValue('StartDir')
local root=if isBeforeStartDir and self._hasPhysicalRoot then 1 else 0
local curDir=if isBeforeStartDir and self:includeCurDir()then 1 else 0

return self:prefixRemaining()+root+curDir
end


function Components.finished(self)
local self=self

local front=self._front
local back=self._back
return front=='Done'or back=='Done'or getStateValue(front)>getStateValue(back)
end

function Components.isSepByte(self,b)
local self=self

return if self:prefixVerbatim()then isVerbatimSep(b)else isSepByte(b)
end

function Components.asPathString(self)
local self=self

local comps=(self:clone())
if comps._front=='Body'then
comps:trimLeft()
end
if comps._back=='Body'then
comps:trimRight()
end
return comps._path
end


function Components.hasRoot(self)
local self=self

if self._hasPhysicalRoot then
return true
end
local prefix=self.prefix
if prefix and prefix:hasImplicitRoot()then
return true
end
return false
end


function Components.includeCurDir(self)
local self=self

if self:hasRoot()then
return false
end

local index=self:prefixRemaining()+1
local first=string.sub(self._path,index,index)
local second=string.sub(self._path,index+1,index+1)

local firstIsDot=first=='.'


return if firstIsDot and second==''
then true
elseif firstIsDot and second~=''then self:isSepByte(second)
else false
end



function Components.parseSingleComponent(self,comp)
local self=self

if comp=='.'then
if self:prefixVerbatim()then
return Component.curDir()
else



return nil
end
elseif comp=='..'then
return Component.parentDir()
elseif comp==''then
return nil
else
return Component.normal(comp)
end
end



function Components.parseNextComponent(self)
local self=self

local path=self._path
local extra=0
local comp=path

for i=1,#path do
if self:isSepByte(string.sub(path,i,i))then
extra=1
comp=string.sub(path,1,i-1)
break
end
end

return#comp+extra,self:parseSingleComponent(comp)
end



function Components.parseNextComponentBack(self)
local self=self

local start=self:lenBeforeBody()+1
local path=self._path

local extra=0
local comp=string.sub(path,start)

for i=#path,start,-1 do
if self:isSepByte(string.sub(path,i,i))then
extra=1
comp=string.sub(path,i+1)
break
end
end

return#comp+extra,self:parseSingleComponent(comp)
end


function Components.trimLeft(self)
local self=self

while self._path~=''do
local size,comp=self:parseNextComponent()
if comp~=nil then
return
else
self._path=string.sub(self._path,size+1)
end
end
end


function Components.trimRight(self)
local self=self

while#self._path>self:lenBeforeBody()do
local size,comp=self:parseNextComponentBack()
if comp~=nil then
return
else
self._path=string.sub(self._path,1,#self._path-size)
end
end
end

function Components.next(self)
local self=self

while not self:finished()do
local front=self._front

if front=='Prefix'then
self._front='StartDir'
local prefixLen=self:prefixLen()
if prefixLen>0 then
local raw=string.sub(self._path,1,prefixLen)
self._path=string.sub(self._path,prefixLen+1)

return Component.prefix(raw,(self.prefix))
end
elseif front=='StartDir'then
self._front='Body'

if self._hasPhysicalRoot then
self._path=string.sub(self._path,2)
return Component.rootDir()
elseif self.prefix~=nil then
if self.prefix:hasImplicitRoot()and not self.prefix:isVerbatim()then
return Component.rootDir()
end
elseif self:includeCurDir()then
self._path=string.sub(self._path,2)
return Component.curDir()
end
elseif front=='Body'then
if self._path~=''then
local size,comp=self:parseNextComponent()
self._path=string.sub(self._path,size+1)

if comp~=nil then
return comp
end
else
self._front='Done'
end
else
error('unreachable')
end
end

return nil
end

function Components.collect(self)
local self=self

return Array.fromFn(function()
return self:next()
end)
end

function Components.rev(self)
local self=self

return Rev.new(self:clone())
end

function Components.nextBack(self)
local self=self

while not self:finished()do
local back=self._back

if back=='Body'then
if#self._path>self:lenBeforeBody()then
local size,comp=self:parseNextComponentBack()
self._path=string.sub(self._path,1,#self._path-size)

if comp~=nil then
return comp
end
else
self._back='StartDir'
end
elseif back=='StartDir'then
self._back='Prefix'
if self._hasPhysicalRoot then
self._path=string.sub(self._path,1,#self._path-1)
return Component.rootDir()
elseif self.prefix~=nil then
local p=self.prefix
if p:hasImplicitRoot()and not p:isVerbatim()then
return Component.rootDir()
end
elseif self:includeCurDir()then
self._path=string.sub(self._path,1,#self._path-1)
return Component.curDir()
end
elseif back=='Prefix'then
self._back='Done'

if self:prefixLen()>0 then
return Component.prefix(self._path,(self.prefix))
end
else
error('unreachable')
end
end

return nil
end

function Components.clone(self)
local self=self

local newSelf=(table.clone(self))

if newSelf.prefix then
newSelf.prefix=newSelf.prefix:clone()
end

return(setmetatable(newSelf,ComponentsMetatable))
end

function Components.equal(self,other)
local self=self
local other=other




if
#self._path==#other._path
and self._front==other._front
and self._back=='Body'
and other._back=='Body'
and self:prefixVerbatim()==other:prefixVerbatim()
then


if self._path==other._path then
return true
end
end


local selfClone=self:clone()
local otherClone=other:clone()

local selfComponent=selfClone:nextBack()
local otherComponent=otherClone:nextBack()

while selfComponent and otherComponent do
if not selfComponent:equal(otherComponent)then
return false
end
selfComponent=selfClone:nextBack()
otherComponent=otherClone:nextBack()
end

return selfComponent==nil and otherComponent==nil
end

return Components end function __DARKLUA_BUNDLE_MODULES.ar()

local Component=__DARKLUA_BUNDLE_MODULES.load('ao')






local function iterAfter(
iter,
prefix
)

while true do

local iterNext=iter:clone()
local x=iterNext:next()
local y=prefix:next()




if x~=nil and y~=nil then
if not x:equal(y)then
return nil
end
elseif y==nil then
return iter
else
return nil
end
iter=iterNext
end
end

return iterAfter end function __DARKLUA_BUNDLE_MODULES.as()



local Disk=__DARKLUA_BUNDLE_MODULES.load('ai')

local Component=__DARKLUA_BUNDLE_MODULES.load('ao')
local Components=__DARKLUA_BUNDLE_MODULES.load('aq')
local Prefix=__DARKLUA_BUNDLE_MODULES.load('aj')
local iterAfter=__DARKLUA_BUNDLE_MODULES.load('ar')
local sysPath=__DARKLUA_BUNDLE_MODULES.load('an')

local Array=Disk.Array

local isSepByte=sysPath.isSepByte
local parsePrefix=sysPath.parsePrefix
local MAIN_SEPARATOR_STR=sysPath.MAIN_SEPARATOR_STR

local IS_WINDOWS=MAIN_SEPARATOR_STR=='\\'





local function hasRedoxScheme(_s)
return false
end
















local Ancestors={}
local AncestorsMetatable={
__index=Ancestors,
}

local function newAncestors(path)
local self={
_next=path,
}

return(setmetatable(self,AncestorsMetatable))
end

function Ancestors.next(self)
local self=self

local next=self._next
self._next=next and next:parent()

return next
end

function Ancestors.collect(self)
local self=self

return Array.fromFn(function()
return self:next()
end)
end

















































local Path={}
local PathMetatable={
__index=Path,
__tostring=function(self)
return self:toString()
end,
}


local function rsplitFileAtDot(file)
if file=='..'then
return file,nil
end






local reversed=string.reverse(file)
local length=#file
local revIndex=string.find(reversed,'.',1,true)

local index=revIndex and(1+length-revIndex)

if index==nil then
return file,nil
end

local after=index and string.sub(file,index+1)
local before=index and string.sub(file,1,index-1)

if before==''then
return file,nil
else
return before,after
end
end

local function splitFileAtDot(file)
if file=='..'then
return file,nil
end





local index=string.find(file,'.',2,true)
if index==nil then
return file,nil
else
local before=string.sub(file,1,index-1)
local after=string.sub(file,index+1)

return before,after
end
end


local function hasPhysicalRoot(s,prefix)
local path=if prefix~=nil then string.sub(s,prefix:len()+1)else s
return path~=''and isSepByte(string.sub(path,1,1))
end

function Path.new(path)
local self={
_inner=path,

_prefix=nil,
}

return(setmetatable(self,PathMetatable))
end

function Path.from(path)
local pathType=type(path)
if pathType=='string'then
return Path.new(path)
elseif Path.is(path)then
return path
elseif Components.is(path)then
return Path.new(path:asPathString())
end

error('unable to create path from value')
end

function Path.is(value)
return type(value)=='table'and getmetatable(value)==PathMetatable
end

function Path.toString(self)
local self=self

return self._inner
end

function Path.toPathBuf(self)
local self=self

return(setmetatable(table.clone(self),PathMetatable))
end

function Path.isAbsolute(self)
local self=self






return self:hasRoot()and((not IS_WINDOWS)or self:_prefix()~=nil)

end

function Path.isRelative(self)
return not self:isAbsolute()
end

function Path.hasRoot(self)
local self=self
return self:components():hasRoot()
end

function Path.parent(self)
local self=self
local comps=self:components()
local comp=comps:nextBack()

if comp then
local compType=comp.type

if compType=='normal'or compType=='curDir'or compType=='parentDir'then
return Path.new(comps:asPathString())
end
end
return nil
end

function Path.ancestors(self)
local self=self

return newAncestors(self)
end

function Path.fileName(self)
local components=self:components()
local p=components:nextBack()

return if p and p.type=='normal'then(p).value else nil
end

function Path.stripPrefix(self,base)
local result=iterAfter(self:components(),Path.from(base):components())

return result and Path.from(result:asPathString())
end

function Path.startsWith(self,base)
return iterAfter(self:components(),Path.from(base):components())~=nil
end

function Path.endsWith(self,child)
return iterAfter(self:components():rev(),Path.from(child):components():rev())~=nil
end

function Path.fileStem(self)
local fileName=self:fileName()

if fileName then
local before,after=rsplitFileAtDot(fileName)

return before or after
end

return nil
end

function Path.filePrefix(self)
local fileName=self:fileName()

if fileName then
local before,after=splitFileAtDot(fileName)

return before or after
end

return nil
end

function Path.extension(self)
local fileName=self:fileName()

if fileName then
local before,after=rsplitFileAtDot(fileName)

return before and after
end

return nil
end

function Path.join(self,path)
local self=self

local buf=self:toPathBuf()
buf:push(path)
return buf
end

function Path.withFileName(self,fileName)
local self=self

local buf=self:toPathBuf()
buf:setFileName(fileName)
return buf
end

function Path.withExtension(self,extension)
local self=self

local buf=self:toPathBuf()
buf:setExtension(extension)
return buf
end

function Path.components(self)
local self=self
local prefix=parsePrefix(self._inner)
return Components.new(
self._inner,
prefix,
hasPhysicalRoot(self._inner,prefix)or hasRedoxScheme(self._inner)
)
end

function Path.equal(self,other)
local self=self
return self:components():equal(other:components())
end

function Path.push(self,path)
local self=self

local path=(Path.from(path))


local needSep=if self._inner==''
then false
else not isSepByte(string.sub(self._inner,-1,-1))


local comps=self:components()

if
comps:prefixLen()>0
and comps:prefixLen()==#(comps)._path
and((comps.prefix)):isDrive()
then
needSep=false
end


if path:isAbsolute()or path:_prefix()~=nil then
self._inner=''


elseif comps:prefixVerbatim()and path._inner~=''then
local buf=comps:collect()
for _,c in path:components():collect()do
if c.type=='rootDir'then
buf={buf[1],c}
elseif c.type=='curDir'then

elseif c.type=='parentDir'then
local lastIndex=#buf
if lastIndex>0 and buf[lastIndex].type=='normal'then
table.remove(buf)
end
else
table.insert(buf,c)
end
end

local res={}
local needSep=false

for _,c in buf do
if needSep and c.type~='rootDir'then
table.insert(res,MAIN_SEPARATOR_STR)
end
table.insert(res,c:toString())

local prefix=(c).parsed
needSep=if c.type=='rootDir'
then false
elseif prefix then not prefix:isDrive()and prefix:len()>0
else true
end

self._inner=table.concat(res,'')
return


elseif path:hasRoot()then
local prefix_len=self:components():prefixRemaining()

self._inner=string.sub(self._inner,1,prefix_len)


elseif needSep then
self._inner..=MAIN_SEPARATOR_STR
end

self._inner..=path._inner
end

function Path.pop(self)
local self=self
local parent=(self:parent())
if parent~=nil then
self._inner=parent._inner
return true
else
return false
end
end

function Path.setFileName(self,fileName)
local self=self

if self:fileName()~=nil then
self:pop()
end
self:push(fileName)
end

function Path.setExtension(self,extension)
local self=self

local fileStem=self:fileStem()

if fileStem==nil then
return false
end

local fileStem=fileStem

self._inner=string.sub(self._inner,1,#fileStem)

if extension~=''then
self._inner..='.'..extension
end

return true
end

function Path.clear(self)
local self=self
self._inner=''
end

function Path._prefix(self)
local self=self
return self:components().prefix
end

return Path end end

local Path=__DARKLUA_BUNDLE_MODULES.load('as')




return{
Path=Path,
}