--[[

仿大厂样式的符号键盘
作者：6486449j
版本：2.0

添加了最近使用功能
合并了 陈勇 的字体读取、部分符号的添加与订正

]]--
require "import"
import "android.widget.*"
--import "android.graphics.Rect"
--import "android.graphics.RectF"
import "android.graphics.Color"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.drawable.StateListDrawable"
import "java.io.File"
--import "android.graphics.Typeface"
import "android.os.*"

--[[local vibeFont=Typeface.DEFAULT
local 字体文件 = service.getLuaDir().."/fonts/symbol.ttf"
if File(字体文件).exists() then
  vibeFont=Typeface.createFromFile(字体文件)
end]]

--键盘高度
local keyboard_height=260
pcall(function()
  keyboard_height=service.getLastKeyboardHeight()
end)
--键盘宽度
local keyboard_width=service.getWidth()

--底部按键高度
local bomBtmHeight=120
local bomBtmWidth=150

--功能键区域宽度
local funbtnWidth=150
local 功能键高度=(keyboard_height-bomBtmHeight)/4-5

--符号
local 符号键高度="45dp"

local 背景色=0xffacb2c2

local 符号键背景色=0xffDDDDDD
local 符号字体色=0xff000000

local 功能键背景色=0xff555d6a
local 功能字体色=0xffffffff

local tsts="20dp" --符号字体大小
local maxRntSymbol=20

function colorDraw(nmcolor,hlcolor)
local stb=StateListDrawable()
  stb.addState({-android.R.attr.state_pressed},nmcolor)
  stb.addState({android.R.attr.state_pressed},hlcolor)
  return stb
end

function bg3(c)
local gd1 = GradientDrawable()
  if c == 1 then  --高亮背景
    cc=0x90009999
    c1=2
    c2=0xff000000
    rr=20	--5
  elseif c == 2 then  --符号键
    cc=符号键背景色
    c1=2
    c2=0x90000000
    rr=20	--10
    --gd1.setShape(GradientDrawable.OVAL)
  else  --功能键
    cc=功能键背景色
    c1=2
    c2=0xff333333
    rr=20	--5
  end
  c=0
    gd1.setColor(cc) --功能键背景色
  --gd1.setColor(Color.rgb(255,124,64))
  gd1.setCornerRadius(rr)
  gd1.setStroke(c1, c2)
  --gd1.setShape(GradientDrawable.OVAL)
  --gd1.setGradientType(GradientDrawable.SWEEP_GRADIENT)
local gd2 = GradientDrawable()
  gd2.setColor(0x00ff0000) --点击功能键时背景色
  gd2.setCornerRadius(rr)
  gd2.setStroke(2, 0xff000000)
return colorDraw(gd1,gd2)
end

--符号
local symbol_icons={"最近","表情","中文","英文","数学","特殊","希腊","动植","音标","颜色","角标","序号","箭头","制表"}
local symbols={
  {},
  [[🙂😂🤣😆🙃😅🙈🙉🙊☹😑😄🤐😨😱🌚🌝🤔❤💔♡🌹💣👌👍😣😥😮🙄😏😕😯😪😫😴😌🤑😉😋😎😍😘😚😛😜😝😒😓😔😲😷🤒😇🤓🤗🤕🙁😖😞😟😤😢😭😦😧😨😩😬😰😳😵😡😠☝✌🖕👎🙏🤘👏💪💋☘🍀🌸☕🍵🍺🍻🍦🍬🍚🍜🍲🍖🎂💤👠🌂👙✍👿👹👺👻💩🌺💥🍂🎋🎍🌴🌳🌲🌵🍁🌾🌹🥀🌼💐🔥💦💧☔☂⛄☃🎃❄🌎🌙⭐🌟✨☀🌤🌦🌧⛈🌩⚡🍏🍎🍐🍊🍋🍌🍉🍇🍓🍒🍑🍍🥭🥝🥥🥑🍅🥬🌶🌽🥢🥣🍴🍼🥤☕🍾🍺🍷🍹🍠🍖🍗🥚🍳🥓🥩🍥🍬🍰🏀⚽🏐🎱🏈⚾🎾🏸🏓🏌🥌⛷🏹🎣🥊🥋🏊🧗🏋🚴🏇🏆🏅🥇🥈🥉🎳🎧🎤🎮🎯🎲🎰🛴🛵🏍🚲🛹🛫🛬🦠🦟🕷🐜🕸🐞🦀🐶🦊🐙🐦🐤🦅🐝🐛🦖🦐🐠🐟🦛🐘🐾🐷🐽🐸🦇🦞⇨🐁🐄🐅🐇🐉🐍🐎🐏🐒🐓🐕🐖⇦⌨🖱💾📒📺📻🔒🔓🖊⏳🔋📚💡🗑💰💳📝⚙💣🚬🧪🧬💊💉🌡🔖🔑🛌🧳🗺🛍🎏🎀🛒🎁🎉🎎🎐✂📁]],
  {"，","。","？","！","～","、","：","＃","；","％","＊","——","……","＆","·","￥","（","）","‘","’","“","”","[","]","『","』","〔","〕","｛","｝","【","】","‖","〖","〗","《","》","「","」","｜","〈","〉","«","»","‹","›"},
  {",",".","@", "~", "_", "-", ":", ";", "*","?","!", "#","/","=","+","```","&","^","%","…","$","(",")","\\","`","<",">","|","·","[","]","'","\"","{","}","¥","€","¡","¿","﹉","´","＂","＇","£","¢","฿","♀","♂"},
  [[1234567890=+-·/×÷^＞＜≥≤≮≯≡≠≈≒±√³√π%‰％℅½⅓⅔¼¾∶∵∴∷㏒㏑∫∬∭∮∯∰∂∑∏∈∉∅⊂⊃⊆⊇⊄⊅⊊⊈⫋⫌∀∃∩∪∧∨⊙⊕∥⊥⌒∟∠△⊿∝∽∞≌°℃℉㎎㎏μm㎜㎝㎞㎡m³㏄㏕]],
  [[△▽○◇□☆▷◁♤♡♢♧▲▼●◆■★▶◀♠♥♦♣囍☼☽☺◐㏂☀☾♂☹◑×✕✘☚☛㏘▪•‥…▁▂▃▄▅▆▇█∷※░▒▓▏▎▍▌▋▊▉♩♪♫♬§〼◎¤۞℗®©♭♯♮‖¶卍卐▬〓℡™㏇☌☍☋☊㉿◮◪◔◕@㈱№♈♉♊♋♌♎♏♐♑♓♒♍☰☱☲☳☯☴☵☶☷*＊✲❈❉✿❀❃❁☸✖✚✪❤ღ❦❧₪✎✍⏍ϟ⚼📝📋✌☁☂☃☄♨☇☈☡➷⊹✉☏☢☣☠☮〄➹☩ஐ☎✈〠۩✙✟☤☥☦☧☨☫☬♟♙♜♖♞♘♝♗♛♕♚♔✄✁✃✂❥✪☒❅✣✰⚀⚁⚂⚃⚄⚅❏❐◲▢▣🎤🌐🔍🇨🇳🔤🔙🔝⌫☑☒❎✔✘✓✗♻♲]],
  [[ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω]],
  [[🐵🐒🦍🦧🐶🐕🦮🐩🐺🦊🦝🐱🐈🦁🐯🐅🐆🐴🐎🦄🦓🦌🦬🐮🐂🐃🐄🐷🐖🐗🐽🐏🐑🐐🐪🐫🦙🦒🐘🦣🦏🦛🐭🐁🐀🐹🐰🐇🐿🦫🦔🦇🐻🐨🐼🦥🦦🦨🦘🦡🐾🦃🐔🐓🐣🐤🐥🐦🐧🕊🦅🦆🦢🦉🦤🪶🦩🦚🦜🐸🐊🐢🦎🐍🐲🐉🦕🦖🐳🐋🐬🦭🐟🐠🐡🦈🐙🐚🐌🦋🐛🐜🐝🪲🐞🦗🪳🕷🕸🦂🦟🪰🪱🦠💐🌸💮🏵🌹🥀🌺🌻🌼🌷🌱🪴🌲🌳🌴🌵🌾🌿☘🍀🍁🍂🍃🍇🍈🍉🍊🍋🍌🍍🥭🍎🍏🍐🍑🍒🍓🫐🥝🍅🫒🥥🥑🍆🥔🥕🌽🌶🫑🥒🥬🥦🧄🧅🍄🥜🌰🍞🥐🥖🫓🥨🥯🥞🧇🧀🍖🍗🥩🥓🍔🍟🍕🌭🥪🌮🌯🫔🥙🧆🥚🍳🥘🍲🫕🥣🥗🍿🧈🧂🥫🍱🍘🍙🍚🍛🍜🍝🍠🍢🍣🍤🍥🥮🍡🥟🥠🥡🦀🦞🦐🦑🦪🍦🍧🍨🍩🍪🎂🍰🧁🥧🍫🍬🍭🍮🍯🍼🥛☕🫖🍵🍶🍾🍷🍸🍹🍺🍻🥂🥃🥤🧋🧃🧉🧊🥢🍽🍴🥄🔪🏺]],
  [[ɑːɔ:ɜːi:u:ʌɒəɪʊeæeɪaɪɔɪɪəeəʊəəʊaʊptkfθsbdgvðzʃhtstʃjtrʒrdzdʒdrwmnŋl]],
  {"FFFFFF","DDDDDD","AAAAAA","888888","666666","444444","000000","FFB7DD","FF88C2","FF44AA","FF0088","C10066","A20055","8C0044","FFCCCC","FF8888","FF3333","FF0000","CC0000","AA0000","880000","FFC8B4","FFA488","FF7744","FF5511","E63F00","C63300","A42D00","FFDDAA","FFBB66","FFAA33","FF8800","EE7700","CC6600","BB5500","FFEE99","FFDD55","FFCC22","FFBB00","DDAA00","AA7700","886600","FFFFBB","FFFF77","FFFF33","FFFF00","EEEE00","BBBB00","888800","EEFFBB","DDFF77","CCFF33","BBFF00","99DD00","88AA00","668800","CCFF99","BBFF66","99FF33","77FF00","66DD00","55AA00","227700","99FF99","66FF66","33FF33","00FF00","00DD00","00AA00","008800","BBFFEE","77FFCC","33FFAA","00FF99","00DD77","00AA55","008844","AAFFEE","77FFEE","33FFDD","00FFCC","00DDAA","00AA88","008866","99FFFF","66FFFF","33FFFF","00FFFF","00DDDD","00AAAA","008888","CCEEFF","77DDFF","33CCFF","00BBFF","009FCC","0088A8","007799","CCDDFF","99BBFF","5599FF","0066FF","0044BB","003C9D","003377","CCCCFF","9999FF","5555FF","0000FF","0000CC","0000AA","000088","CCBBFF","9F88FF","7744FF","5500FF","4400CC","2200AA","220088","D1BBFF","B088FF","9955FF","7700FF","5500DD","4400B3","3A0088","E8CCFF","D28EFF","B94FFF","9900FF","7700BB","66009D","550088","F0BBFF","E38EFF","E93EFF","CC00FF","A500CC","7A0099","660077","FFB3FF","FF77FF","FF3EFF","FF00FF","CC00CC","990099","770077","f7acbc","deab8a","817936","444693","ef5b9c","fedcbd","7f7522","2b4490","feeeed","f47920","80752c","2a5caa","f05b72","905a3d","87843b","224b8f","f15b6c","8f4b2e","726930","003a6c","f8aba6","87481f","454926","102b6a","f69c9f","5f3c23","2e3a1f","426ab3","f58f98","6b473c","4d4f36","46485f","ca8687","faa755","b7ba6b","4e72b8","f391a9","fab27b","b2d235","181d4b","bd6758","f58220","5c7a29","1a2933","d71345","843900","bed742","121a2a","d64f44","905d1d","7fb80e","0c212b","d93a49","8a5d19","a3cf62","6a6da9","b3424a","8c531b","769149","585eaa","c76968","826858","6d8346","494e8f","bb505d","64492b","78a355","afb4db","987165","ae6642","abc88b","9b95c9","ac6767","56452d","74905d","6950a1","973c3f","96582a","cde6c7","6f60aa","b22c46","705628","1d953f","867892","a7324a","4a3113","77ac98","918597","aa363d","412f1f","007d65","6f6d85","ed1941","845538","84bf96","594c6d","f26522","8e7437","45b97c","694d9f","d2553d","69541b","225a1f","6f599c","b4534b","d5c59f","367459","8552a1","ef4136","cd9a5b","007947","543044","c63c26","cd9a5b","40835e","63434f","f3715c","b36d41","2b6447","7d5886","a7573b","df9464","005831","401c44","aa2116","b76f40","006c54","472d56","b64533","ad8b3d","375830","45224a","b54334","dea32c","274d3d","411445","853f04","d1923f","375830","4b2f3d","840228","c88400","27342b","402e4c","7a1723","c37e00","65c294","c77eb5","a03939","c37e00","73b9a2","ea66a6","8a2e3b","e0861a","72baa7","f173ac","8e453f","ffce7b","005344","fffffb","8f4b4a","fcaf17","122e29","fffef9","892f1b","ba8448","293047","f6f5ec","6b2c25","896a45","00ae9d","d9d6c3","733a31","76624c","508a88","d1c7b7","54211d","6d5826","70a19f","f2eada","78331e","ffc20e","50b7c1","d3d7d4","53261f","fdb933","00a6ac","999d9c","f15a22","d3c6a6","78cdd1","a1a3a6","b4533c","c7a252","008792","9d9087","84331f","dec674","94d6da","8a8c8e","f47a55","b69968","afdfe4","74787c","f15a22","c1a173","5e7c85","7c8577","f3704b","dbce8f","76becc","72777b","da765b","ffd400","90d7ec","77787b","c85d44","ffd400","009ad6","4f5555","ae5039","ffe600","145b7d","6c4c49","6a3427","f0dc70","11264f","563624","8f4b38","fcf16e","7bbfea","3e4145","8e3e1f","decb00","33a3dc","3c3645","f36c21","cbc547","228fbd","464547","b4532a","6e6b41","2468a2","130c0e","b7704f","596032","2570a1","281f1d","de773f","525f42","2585a6","2f271d","c99979","5f5d46","1b315e"},
  [[º⁰¹²³⁴⁵⁶⁷⁸⁹ⁱ⁺⁻⁼⁽⁾ˣʸⁿᶻˢ₀₁₂₃₄₅₆₇₈₉₊₋₌₍₎ₐₑₒₓᵧₔᴬᴮᶜᴰᴱᶠᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾᶞᴿᵀᵁᵛᵂᵃᵇᶜᵈᵉᶠᵍʰⁱʲᵏˡᵐⁿᵒᵖʳˢᵗᵘᵛʷˣʸᶻ]],
  [[①②③④⑤⑥⑦⑧⑨⑩❶❷❸❹❺❻❼❽❾❿⓵⓶⓷⓸⓹⓺⓻⓼⓽⓾⒈⒉⒊⒋⒌⒍⒎⒏⒐⒑⑴⑵⑶⑷⑸⑹⑺⑻⑼⑽㈠㈡㈢㈣㈤㈥㈦㈧㈨㈩壹贰叁肆伍陆柒捌玖拾佰仟萬億ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩⅪⅫ]],
  [[→←↑↓↖↗↙↘↔↕⇞⇟⇆⇅⇔⇕↰↱↲↴↶↷↺↻↜↝↞↟↠↡➺➻➼➳➽➸➹➷⇎➠↣☞☜☟⇦⇧⇨⇩⇪➩➪➫➬➯➱➮➭➠➡➢➣➤➥➦➧➨]],
  [[┝┞┟┠┡┢═╞╟╡╢╪┭┮┯┰┱┲║╤╥╧╨╫┥┦┧┨┩┪┽┾┿╀╁╂┵┶┷┸┹┺╄╅╆╇╈╉┈┉┊┋╃╊┍┑┕┙┎┒┖┚╒╕╘╛╓╖╙╜┄┅┆┇┌┬┐├┼┤└┴┘┏┳┓┣╋┫┗┻┛╔╦╗╠╬╣╚╩╝]],
}
--输入法数据路径
local rimePath=tostring(service.getLuaExtDir("")).."/"

--储存最近使用符号的文件路径
local recentSymbolPath=rimePath.."recent_symbol.txt"

local rntSymbol={}

--判断文件是否存在
if not File(recentSymbolPath).exists()
  File(recentSymbolPath).createNewFile()
end

local function revertTable(t)
  local tmp={}
  for i in ipairs(t)
    table.insert(tmp, i)
  end
  return tmp
end

--插入最近符号
local function insertRntSymbol(s)
  local j=0
  for i, k in ipairs(rntSymbol) do
    j=j+1
    if k==s
      table.remove(rntSymbol, j)
    end
  end
  table.insert(rntSymbol, 1, s)
end

--更新最近符号
local function genRntSymbol()
  symbols[1]=rntSymbol
end

--从文本文件中读取最近符号
for s in io.lines(recentSymbolPath) do
  table.insert(rntSymbol, tostring(s))
end

genRntSymbol()

--生成储存在文本文件里的带回车的字符串
local function genRntSybFileStr()
  local str=""
  for i,k in ipairs(rntSymbol) do
    str=str..k.."\n"
  end
  return str
end

--预设置tab页为:第三个
local currSelect=1

local layout_ids={}

local curr_tab_id="tab"..tostring(currSelect)
local last_tab_id=""

--获取k功能图标，没有返回s
local function icon(k,s)
  k=Key.presetKeys[k]
  return k and k.label or s
end


local data={}
local item={
  LinearLayout,
  layout_height=符号键高度,  --符号区域_符号键高度
  layout_width=-1,
  gravity="center",
  {
    TextView,
    id="text",
    layout_width=-1,
    layout_height=-1,
    layout_margin="2dp",
    layout_marginTop="3dp",
    textColor=符号字体色,
    gravity="center",
    textSize=tsts,
--    Typeface=vibeFont,
    background=bg3(2)
}}
local adp=LuaAdapter(service, data, item)

--生成侧边功能键
local function getFunKeys()
  local funbtnHeight=功能键高度
  local layout={LinearLayout,
    Orientation=1,
    layout_padding=0,
    layout_width="fill",
orientation="vertical",
    {Button,
      id="back",
      text=icon("", "返回"),
      textColor=功能字体色,
      layout_height=funbtnHeight,
      Typeface=vibeFont,
      onClick=function()
        local str=genRntSybFileStr()
        io.open(recentSymbolPath,"w"):write(str):close()
        service.sendEvent("Keyboard_default")
      end,
      layout_marginTop="2dp",
      layout_margin="1dp",
      layout_marginBottom="2dp",
vertical="5dp",
shadowColor=0xffff0000,
shadowRadius=1,
shadowDx=5,
shadowDy=5,
      background=bg3(0)
    },
    {Button,
      text=icon("", "空格"),
      textColor=功能字体色,
      layout_height=funbtnHeight,
      Typeface=vibeFont,
      onClick=function()

        service.sendEvent("space")
      end,
      layout_margin="1dp",
      layout_marginBottom="2dp",
      background=bg3(0)
    },
    {Button,
      text=icon("","⌫"),
      textColor=功能字体色,
      layout_height=funbtnHeight,
      Typeface=vibeFont,
      textSize="24dp",
      onClick=function()
        service.sendEvent("BackSpace")
      end,
      layout_margin="1dp",
      layout_marginBottom="2dp",
      background=bg3(0)
    },
    {Button,
      text=icon("", "回车"),
      textColor="#00BBFF",
      layout_height=funbtnHeight,
      Typeface=vibeFont,
      onClick=function()
        service.sendEvent("Return")
      end,
      layout_margin="1dp",
      layout_marginBottom="2dp",
      background=bg3(0)
    }
  }
  return layout
end

--生成符号列表
local function genContentList()
  table.clear(data)
  local tmp_sym=symbols[currSelect]
  if type(tmp_sym)=="string" then
    local temp={}
    for a in utf8.gmatch(tostring(tmp_sym),"%S")
      table.insert(temp,a)
    end
    tmp_sym=temp
  end

  for _,v in ipairs(tmp_sym) do
    if currSelect~=10 then
      table.insert(data,{
    text={
      Text=v, 
      TextColor=符号字体色,
      Background=bg3(2),
    }, 
  })
    else
      table.insert(data,{
    text={
      Text=v, 
      BackgroundColor=Color.parseColor("#" ..v),
      TextColor=0x00000000,
    }, 
  })
   end
  end
  adp.notifyDataSetChanged()
end

--生成底部按键
local function getBottomKeys()
  local layout={HorizontalScrollView,
    {LinearLayout,
      Orientation=0,
      layout_padding=0
    }
  }
  for i in ipairs(symbol_icons)
    local btn={Button,
      id="tab"..tostring(i),
      text=tostring(symbol_icons[i]),
      layout_width=bomBtmWidth,
      layout_height=bomBtmHeight,
      textColor=功能字体色,
      Typeface=vibeFont,
      layout_margin=1,
      layout_marginTop="-1dp",
      background=bg3(0),
      onClick=function()
        last_tab_id=curr_tab_id
        curr_tab_id="tab"..tostring(i)
        currSelect=i
        if i==1
          genRntSymbol()
        end
        genContentList()
        adp.notifyDataSetChanged()

        if curr_tab_id ~= last_tab_id then
          if curr_tab_id~="" then
            layout_ids[curr_tab_id].setBackground(bg3(1))
          end
          if last_tab_id~="" then
            layout_ids[last_tab_id].setBackground(bg3(0))
          end
        end
        layout_ids.list.smoothScrollToPosition(0)
      end
    }

    table.insert(layout[2], btn)
  end

  return layout
end

--主布局
local layout = {
  FrameLayout,
  layout_height=keyboard_height,
  layout_width=-1,
  BackgroundColor=背景色,
  {LinearLayout,
    id="main",
    orientation=1,
    {LinearLayout,
      id="se",
      orientation=1,
      layout_height=keyboard_height-bomBtmHeight,
      {LinearLayout,
        layout_width="match_parent",
        Orientation=0,
        {GridView,
          id="list",
          numColumns=7, --每行数量
          layout_width=keyboard_width-funbtnWidth},
        getFunKeys()
      }
    },
    getBottomKeys()
  }
}
layout=loadlayout(layout, layout_ids)

genContentList()

layout_ids.list.Adapter=adp

layout_ids.list.onItemClick=function(l,v,p,i)
  local s=data[p+1].text.Text
  if curr_tab_id=="tab2" or curr_tab_id=="tab4" or curr_tab_id=="tab5" then insertRntSymbol(s) end
  service.commitText(s)
end

--高亮当前tab
if curr_tab_id~="" then
  layout_ids[curr_tab_id].setBackground(bg3(1))
end

service.setKeyboard(layout)

