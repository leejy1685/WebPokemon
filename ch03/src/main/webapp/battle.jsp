<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
 <%@ page import="java.io.PrintWriter,com.google.gson.Gson , java.util.*,
 웹프기말_포켓몬.PocketmonEntity, 웹프기말_포켓몬.PocketmonDBCP, 웹프기말_포켓몬.SkillEntity,웹프기말_포켓몬.PropertyEntity"%>
<jsp:useBean id="DBCP" class="웹프기말_포켓몬.PocketmonDBCP" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>BattleSceen</title>
<style type="text/css">
      div.enumy{
      width: 300px; 
      heigth:20px;
      box-shadow: -5px 10px black;
      text-align: center;
      float:left;
      }
      div.healthBar{
      width: 100%;
      height:10px;
      border-radius: 15px;
      background-color: red;
      float:left;   
      }
      div.health{
      width: 250px;
      height:10px;
      border-radius: 15px;
      border:3px solid;
      float:left;   
      }
      div.user{
      width: 300px; 
      heigth:20px;
      box-shadow: 5px 10px black;
      text-align: center;
      float:right;
      }
      div.textBox{
      width: 100%;
      height: 250px;
      border:5px solid;
      font-size:80px;
      }
      div.test{
      position:absolute;
      width: 500px;
      height: 400px;
      border:5px solid;
      background-color:white;
      left:25%;
      top:50%;
      font-size:60px;'
      }
      
      body{height:100%;}
      header{width: 100%;height: 20%;}
        aside{float: left; width: 25%;height: 70%;}
        section{float: left;width: 50%;height: 70%;}
        nav{float: left;width: 25%;height: 70%;}
        footer{width: 100%;height: 10%;clear: both;}
        
        div.ani1{
        position: absolute;
         width: 300px;
        height: 300px;
        animation-name: move1;
        animation-duration: 5s;
         animation-iteration-count: 1;
         left:60%;
      
        }
       @keyframes move1 {
       from { left: 25%; }
       to   { left: 60%; }
       }
       div.ani2{
        position: absolute;
         width: 300px;
        height: 300px;
        animation-name: move2;
        animation-duration: 5s;
         animation-iteration-count: 1;
         left:25%;
      
        }
       @keyframes move2 {
       from { left: 60%; }
       to   { left: 25%; }
       }
      
</style>
<script type="text/javascript">
var count=0;
var turn =0;
var skillNum=0;
var eh,uh;
var starting=true;
var num=0;
var pNum=1;
var itemCou=3;
var alive1 = true;
var alive2 = true;
var alive3 = true;

class Skill {
    constructor (id, name,type,damage,accuracy){
      this.id = id;
      this.name = name;
      this.type = type;
      this.damage = damage;
      this.accuracy = accuracy;
    }
}
class Pokemon {
    constructor (id, name,type,damage,defense,health,alive){
      this.id = id;
      this.name = name;
      this.type = type;
      this.damage = damage;
      this.defense = defense;
      this.health = health;
    }
}
class Type{
   constructor(type,strong,weak){
      this.type = type;
      this.strong = strong;
      this.weak = weak;
   }
}
function startGame(){
    var bgm = document.getElementById("bgm").play();
}
function printNext(){
   
   count++;
   
   console.log("turn"+turn);
   console.log(count);
   startGame();
   
   updatePage();

   
}
</script>
</head>
<body>
<aside>
<audio src="img/audio/battle.mp3" controls loop id="bgm"></audio>
<br>
</aside>
<section>
<div class="ani1" id="ani1">
<img src="img/enumy1.png" width="300px" height="300px" id="enumy" >
</div>
<div style="width:100%;height:300px;" name="block"><br>
<img src="img/enumy2.png"  width="300px" id="enumy2">
<table style="box-shadow: -5px 10px black; display:none; width:300px;" id="enumyHealth">
   <tr>
      <th colspan=2 style="font-size:40px" id="ePokemonName"></th>
   </tr>
   <tr>
      <td>HP:</td>
      <td><div class="health"><div class="healthBar" style="width:100%;"id="eh"></div></div></td>
   </tr>
</table>
</div>
</section>
<nav><br></nav>
<footer><br></footer>
<header></header>
<aside><br></aside>
<section>
<div class="ani2" id="ani2">
<img src="img/user1.png" width="300px" height="300px" id="user" >
</div>
<div style="width:100%;height:300px;" name="block"><br>
<img src="img/user2.png" style="float:right;" width="300px" id="user2">
<table style="box-shadow: 5px 10px black; float:right;display:none;" id="userHealth">
   <tr>
      <th colspan=2 style="font-size:40px" id="uPokemonName"></th>
   </tr>
   <tr>
      <td>HP:</td>
      <td><div class="health"><div class="healthBar" style="width:100%;"id="uh"></div></div></td>
   </tr>
   <tr>
      <td colspan=2 style="font-size:40px;text-align:center;" id="uPokemonHp"></td>
   </tr>
</table>
</div>
</section>
<nav><br></nav>
<footer><br></footer>
<header><br></header>
<aside><br></aside>
<section>
<div class="test" id="skillBox" style="display:none;"></div>
<div class="textBox" onClick="printNext()" id="textBox"></div>
</section>
<nav><br></nav>
<footer><br></footer>
<%
//포켓몬 이름 받아옴.
String pokemon1 = (String) session.getAttribute("pokemon1");
String pokemon2 = (String) session.getAttribute("pokemon2");
String pokemon3 = (String) session.getAttribute("pokemon3");

PocketmonEntity pocketmon1 = DBCP.getPocketmon(pokemon1);
List<SkillEntity> skills_1 = DBCP.getSkillsByPokemonName(pokemon1);
pocketmon1.setSkills(skills_1,pocketmon1); // 포켓몬 객체에 스킬 리스트를 설정
// 각 스킬의 이름을 출력
for (SkillEntity skill : skills_1) {
    System.out.println("포켓몬1: 스킬이름: "+skill.getSkillName());
}


PocketmonEntity pocketmon2 = DBCP.getPocketmon(pokemon2);//포켓몬객체로 잘가져옴
List<SkillEntity> skills_2 = DBCP.getSkillsByPokemonName(pokemon2);//리스트로도 제대로 가져옴
pocketmon2.setSkills(skills_2,pocketmon2); // 포켓몬 객체에 스킬 리스트를 설정
//각 스킬의 이름을 출력
for (SkillEntity skill : skills_2) {
 System.out.println("포켓몬2: 스킬이름: "+skill.getSkillName());
}

PocketmonEntity pocketmon3 = DBCP.getPocketmon(pokemon3);//포켓몬객체로 잘가져옴
List<SkillEntity> skills_3 = DBCP.getSkillsByPokemonName(pokemon3);//리스트로도 제대로 가져옴
pocketmon3.setSkills(skills_3,pocketmon3); // 포켓몬 객체에 스킬 리스트를 설정
//각 스킬의 이름을 출력
for (SkillEntity skill : skills_3) {
 System.out.println("포켓몬3: 스킬이름: "+skill.getSkillName());
}

SkillEntity[] skill1 = new SkillEntity[4];
SkillEntity[] skill2 = new SkillEntity[4];
SkillEntity[] skill3 = new SkillEntity[4];


for(int i=0;i<4;i++){
   skill1[i] = skills_1.get(i);
   skill2[i] = skills_2.get(i);
   skill3[i] = skills_3.get(i);
}

/*PocketmonEntity[] randPocketmon = new PocketmonEntity[3];
List<PocketmonEntity> randomPocketmon = DBCP.getRandomPocketmon(); // 포켓몬 리스트를 가져옵니다.
Random rand = new Random();

for(int i=0; i < 3; i++){
   randPocketmon[i] = randomPocketmon.get(rand.nextInt(3));
   System.out.println(randPocketmon[i]);
}*/
PocketmonEntity[] randPocketmon = new PocketmonEntity[3];
List<PocketmonEntity> randomPocketmon = DBCP.getRandomPocketmon(); // 포켓몬 리스트를 가져옵니다.

Random rand = new Random();

// 리스트의 크기가 3 미만인 경우를 처리합니다.
if (randomPocketmon.size() < 3) {
    System.out.println("리스트에 포켓몬이 충분하지 않습니다.");
    return; // 또는 다른 적절한 처리를 수행합니다.
}

// 임시 리스트를 생성하여 중복 선택을 방지합니다.
List<PocketmonEntity> tempList = new ArrayList<>(randomPocketmon);

for (int i = 0; i < randPocketmon.length; i++) {
    int randomIndex = rand.nextInt(tempList.size()); // 랜덤 인덱스 생성
    randPocketmon[i] = tempList.get(randomIndex); // 랜덤 인덱스의 포켓몬을 배열에 저장

    // 선택된 포켓몬을 임시 리스트에서 제거합니다.
    tempList.remove(randomIndex);

    // 선택된 포켓몬을 출력합니다.
    System.out.println("상대방 랜덤포켓몬: "+randPocketmon[i].getName());
}

List<SkillEntity> AI_skills_1 = DBCP.getSkillsByPokemonName(randPocketmon[0].getName());
randPocketmon[0].setSkills(AI_skills_1,randPocketmon[0]); // 포켓몬 객체에 스킬 리스트를 설정
List<SkillEntity> AI_skills_2 = DBCP.getSkillsByPokemonName(randPocketmon[1].getName());
randPocketmon[1].setSkills(AI_skills_1,randPocketmon[1]); // 포켓몬 객체에 스킬 리스트를 설정
List<SkillEntity> AI_skills_3 = DBCP.getSkillsByPokemonName(randPocketmon[2].getName());
randPocketmon[2].setSkills(AI_skills_1,randPocketmon[2]); // 포켓몬 객체에 스킬 리스트를 설정



for (SkillEntity skill : AI_skills_1) {
    System.out.println("상대 포켓몬1: 스킬이름: "+skill.getSkillName());
}
for (SkillEntity skill : AI_skills_2) {
    System.out.println("상대 포켓몬2: 스킬이름: "+skill.getSkillName());
}
for (SkillEntity skill : AI_skills_3) {
    System.out.println("상대 포켓몬3: 스킬이름: "+skill.getSkillName());
}

SkillEntity[] eSkill1 = new SkillEntity[4];
SkillEntity[] eSkill2 = new SkillEntity[4];
SkillEntity[] eSkill3 = new SkillEntity[4];
for(int i=0;i<4;i++){
	   eSkill1[i] = AI_skills_1.get(i);
	   eSkill2[i] = AI_skills_2.get(i);
	   eSkill3[i] = AI_skills_3.get(i);
	}


%>
   
   <script type="text/javascript">


   var ePokemon = new Pokemon(<%=randPocketmon[0].getId()%>,"<%=randPocketmon[0].getName()%>","<%=randPocketmon[0].getProperty()%>",
         <%=randPocketmon[0].getSTR()%>,<%=randPocketmon[0].getDEX()%>,<%=randPocketmon[0].getHP()%>);
   var uPokemon = new Pokemon(<%=pocketmon1.getId()%>,"<%=pocketmon1.getName()%>","<%=pocketmon1.getProperty()%>",
         <%=pocketmon1.getSTR()%>,<%=pocketmon1.getDEX()%>,<%=pocketmon1.getHP()%>);
   //교체시 체력데이터 불러오기 위한 
   var uPokemon1 = new Pokemon(<%=pocketmon1.getId()%>,"<%=pocketmon1.getName()%>","<%=pocketmon1.getProperty()%>",
         <%=pocketmon1.getSTR()%>,<%=pocketmon1.getDEX()%>,<%=pocketmon1.getHP()%>);
   var uPokemon2 = new Pokemon(<%=pocketmon2.getId()%>,"<%=pocketmon2.getName()%>","<%=pocketmon2.getProperty()%>",
         <%=pocketmon2.getSTR()%>,<%=pocketmon2.getDEX()%>,<%=pocketmon2.getHP()%>);
   var uPokemon3 = new Pokemon(<%=pocketmon3.getId()%>,"<%=pocketmon3.getName()%>","<%=pocketmon3.getProperty()%>",
         <%=pocketmon3.getSTR()%>,<%=pocketmon3.getDEX()%>,<%=pocketmon3.getHP()%>);

   var uType = new Type();
   var eType = new Type();

   function setType(){
      if(uPokemon.type == "노말")
         uType = new Type("노말","","");
      else if(uPokemon.type == "불꽃")
         uType = new Type("불꽃","풀","물");
      else if(uPokemon.type == "풀")
         uType = new Type("풀","물/전기/땅","불꽃");
      else if(uPokemon.type == "물")
         uType = new Type("물","불꽃","풀/전기");
      else if(uPokemon.type == "전기")
         uType = new Type("전기","물","땅");
      else if(uPokemon.type == "땅")
         uType = new Type("땅","불꽃/전기","물/풀");

      if(ePokemon.type == "노말")
            eType = new Type("노말","","");
      else if(ePokemon.type == "불꽃")
         eType = new Type("불꽃","풀","물");
      else if(ePokemon.type == "풀")
         eType = new Type("풀","물/전기/땅","불꽃");
      else if(ePokemon.type == "물")
         eType = new Type("물","불꽃","풀/전기");
      else if(ePokemon.type == "전기")
         eType = new Type("전기","물","땅");
      else if(ePokemon.type == "땅")
         eType = new Type("땅","불꽃/전기","물/풀");

   }



   var uskill1 =new Skill(<%=skill1[0].getNum()%>,"<%=skill1[0].getSkillName()%>","<%=skill1[0].getProperty()%>",
         <%=skill1[0].getPower()%>,<%=skill1[0].getAccuracy()%>);
   var uskill2 =new Skill(<%=skill1[1].getNum()%>,"<%=skill1[1].getSkillName()%>","<%=skill1[1].getProperty()%>",
         <%=skill1[1].getPower()%>,<%=skill1[1].getAccuracy()%>);
   var uskill3 =new Skill(<%=skill1[2].getNum()%>,"<%=skill1[2].getSkillName()%>","<%=skill1[2].getProperty()%>",
         <%=skill1[2].getPower()%>,<%=skill1[2].getAccuracy()%>);
   var uskill4 =new Skill(<%=skill1[3].getNum()%>,"<%=skill1[3].getSkillName()%>","<%=skill1[3].getProperty()%>",
         <%=skill1[3].getPower()%>,<%=skill1[3].getAccuracy()%>);

   
   var eskill1 =new Skill(<%=eSkill1[0].getNum()%>,"<%=eSkill1[0].getSkillName()%>","<%=eSkill1[0].getProperty()%>",
         <%=eSkill1[0].getPower()%>,<%=eSkill1[0].getAccuracy()%>);
   var eskill2 =new Skill(<%=eSkill1[1].getNum()%>,"<%=eSkill1[1].getSkillName()%>","<%=eSkill1[1].getProperty()%>",
         <%=eSkill1[1].getPower()%>,<%=eSkill1[1].getAccuracy()%>);
   var eskill3 =new Skill(<%=eSkill1[2].getNum()%>,"<%=eSkill1[2].getSkillName()%>","<%=eSkill1[2].getProperty()%>",
         <%=eSkill1[2].getPower()%>,<%=eSkill1[2].getAccuracy()%>);
   var eskill4 =new Skill(<%=eSkill1[3].getNum()%>,"<%=eSkill1[3].getSkillName()%>","<%=eSkill1[3].getProperty()%>",
         <%=eSkill1[3].getPower()%>,<%=eSkill1[3].getAccuracy()%>);

   
   function diff(){
      var n = confirm("난이도를 선택하시오: (확인: 하드/취소: 노말)");
   }

   function updatePage(){
      var textBox = document.getElementById("textBox");
      eh = document.getElementById("eh").style.width.slice(0, -1);
      uh = document.getElementById("uh").style.width.slice(0, -1);
      
      if(turn==0){
         if(count==1){
            textBox.innerHTML="곤충소년(이)가 승부를 걸어왔다!";
         }
         else if(count==2){
            textBox.innerHTML="곤충소년는(은) "+ePokemon.name+"를(을) 차례로 꺼냈다.";
         }
         else if(count==3){
            textBox.innerHTML="가랏! "+uPokemon.name+"!";
         }
         else if(count==4){
            turn =2;
         }
      }
      
      
      if(count==3 && starting){
            var enumy = document.getElementById("enumy");
            var user = document.getElementById("user");
            var enumy2 = document.getElementById("enumy2");
            var user2 = document.getElementById("user2");
            
            enumy.style.display="none";
            user.style.display="none";   
            enumy2.style.display="none";
            user2.style.display="none";
            
            const enumyPoket=document.createElement("img");
            enumyPoket.src="img/"+ePokemon.id+"f.png";
            enumyPoket.style.width="300px";
            enumyPoket.style.height="300px";
            var ani1=document.getElementById("ani1");
            ani1.appendChild(enumyPoket);
            
            var enumyHealth=document.getElementById("enumyHealth");
            document.getElementById("ePokemonName").innerHTML = ePokemon.name+":L60"; 
            enumyHealth.style.display="block";
            
            const userPoket=document.createElement("img");
            userPoket.src="img/"+uPokemon.id+"b.png";
            userPoket.style.width="300px";
            userPoket.style.height="300px";
            var ani2=document.getElementById("ani2");
            ani2.appendChild(userPoket);
            
            var userHealth=document.getElementById("userHealth");
            document.getElementById("uPokemonName").innerHTML = uPokemon.name+":L60"; 
            document.getElementById("uPokemonHp").innerHTML = uPokemon.health+"/"+uPokemon.health; 
            userHealth.style.display="block";
            starting=false
      }
      if(turn==1){
         setType();

         if(num==1){var sk = uskill1;}
         else if(num==2){var sk = uskill2;}
         else if(num==3){var sk = uskill3;}
         else if(num==4){var sk = uskill4;}            
         if(count==1){
            textBox.innerHTML =uPokemon.name+"의 "+sk.name+"!";
         }
         
         acc = Math.floor(Math.random() * 101);
         
         if(sk.accuracy < acc && count==2 )
            textBox.innerHTML = "그러나 "+uPokemon.name+"의 공격은 빗나갔다!";
         else if(sk.accuracy >= acc && count==2 && eType.weak.includes(sk.type)){
            var hp = eh/100*ePokemon.health - ((uPokemon.damage * sk.damage * 13)/ePokemon.defense/50+2)*1.5;
            if(hp<=0){hp=0;count=0;turn=5;}
            eh = hp/ePokemon.health*100;
            document.getElementById("eh").style.width =eh+"%";
            textBox.innerHTML = "효과가 굉장했다!";
         }
         else if(sk.accuracy >= acc && count==2 && eType.strong.includes(sk.type)){
            var hp = eh/100*ePokemon.health - ((uPokemon.damage * sk.damage * 13)/ePokemon.defense/50+2)/2;
            if(hp<=0){hp=0;count=0;turn=5;}
            eh = hp/ePokemon.health*100;
            document.getElementById("eh").style.width =eh+"%";
            textBox.innerHTML = "효과가 별로다!";
         }
         else if(sk.accuracy >= acc && count==2){
             var hp = eh/100*ePokemon.health - ((uPokemon.damage * sk.damage * 13)/ePokemon.defense/50+2);
             if(hp<=0){hp=0;count=0;turn=5;}
             eh = hp/ePokemon.health*100;
             document.getElementById("eh").style.width =eh+"%";
          }
            
         
         rans = Math.floor(Math.random() * 4);
         if(rans==0){var sk = eskill1;}
         else if(rans==1){var sk = eskill2;}
         else if(rans==2){var sk = eskill3;}
         else if(rans==3){var sk = eskill4;}   
         if(count==3){
            textBox.innerHTML =ePokemon.name+"의 "+sk.name+"!";
         }
         var maxHealth;
         if(pNum==1){maxHealth=<%=pocketmon1.getHP()%>;}
         else if(pNum==2){maxHealth=<%=pocketmon2.getHP()%>;}
         else if(pNum==3){maxHealth=<%=pocketmon3.getHP()%>;}
         
         acc = Math.floor(Math.random() * 101);
         if(sk.accuracy < acc && count==4)
            textBox.innerHTML = "그러나 "+ePokemon.name+"의 공격은 빗나갔다!";
         else if(sk.accuracy >= acc && count==4 && uType.weak.includes(sk.type)){
            var hp = uh/100*uPokemon.health - ((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)*1.5;
            
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 굉장했다!";
         }
         else if(sk.accuracy >= acc && count==4 && uType.strong.includes(sk.type)){
            var hp = uh/100*uPokemon.health - ((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)/2;
            
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 별로다";
         }
         else if(sk.accuracy >= acc && count==4){
             var hp = uh/100*uPokemon.health - ((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2);
             
             if(hp<=0){hp=0;count=0;turn=6;}
             uh = hp/maxHealth*100;
             
             document.getElementById("uh").style.width =uh+"%";
             document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
          }
         if(count==5)
            turn =2;
         
      }

      
      if(turn==2){
         textBox.innerHTML="";
         select = document.createElement("div");
         select.style.width = "60%";
         select.style.heigth= "100%";
         select.style.float = "right";
         select.style.border="5px solid";
         select.style.textAlign="right";
         sel = document.createElement("table");
         sel.style.width = "100%";
         tr1 = document.createElement("tr");
         tr2 = document.createElement("tr");
         
         battleCur = document.createElement("div");
         battleCur.setAttribute("id","battleCur");
         battleCur.style.float ="left";
         battleCur.innerHTML="▶";
         battleCur.style.display="none"
         
         battle = document.createElement("div");
         battle.setAttribute("id","battle");

         battle.style.float ="left";
         battle.innerHTML="싸운다";
         battle.addEventListener("mouseover",(event) => {
            battleCur.style.display="block";
         });
         battle.addEventListener("mouseout",(event) => {
            battleCur.style.display="none";
         });
         battle.addEventListener("click",(event) => {
            skillBox=document.getElementById("skillBox");
            skillBox.innerHTML="";
            sel.style.display = "none";
            skill = document.createElement("table");
            sk1 = document.createElement("tr");
            sk2 = document.createElement("tr");
            sk3 = document.createElement("tr");
            sk4 = document.createElement("tr");
            sk1_1 = document.createElement("td");
            sk2_1 = document.createElement("td");
            sk3_1 = document.createElement("td");
            sk4_1 = document.createElement("td");
            sk1_1.innerHTML="▶";
            sk1_1.style.float="left";
            sk1_1.style.display="none";
            sk2_1.innerHTML="▶"; 
            sk2_1.style.float="left";
            sk2_1.style.display="none";
            sk3_1.innerHTML="▶";
            sk3_1.style.float="left";
            sk3_1.style.display="none";
            sk4_1.innerHTML="▶";
            sk4_1.style.float="left";
            sk4_1.style.display="none";
            sk1_2 = document.createElement("td");
            sk2_2 = document.createElement("td");
            sk3_2 = document.createElement("td");
            sk4_2 = document.createElement("td");
            sk1_2.style.float="left";
            sk2_2.style.float="left";
            sk3_2.style.float="left";
            sk4_2.style.float="left";
            sk1_2.innerHTML=uskill1.name;
            sk1_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               skill.style.display="none";
               turn=1;
               count=0;
               num=1;
            });
            sk1_2.addEventListener("mouseover",(event) => {
               sk1_1.style.display="block";
               select.innerHTML = "기술타입 /"+uskill1.type;
            });
            sk1_2.addEventListener("mouseout",(event) => {
               sk1_1.style.display="none";
               select.innerHTML = "";
            });
            sk2_2.innerHTML=uskill2.name;
            sk2_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               skill.style.display="none";
               turn=1;
               count=0;
               num=2;
            });
            sk2_2.addEventListener("mouseover",(event) => {
               sk2_1.style.display="block";
               select.innerHTML = "기술타입 /"+uskill1.type;
            });
            sk2_2.addEventListener("mouseout",(event) => {
               sk2_1.style.display="none";
               select.innerHTML = "";
            });
            sk3_2.innerHTML=uskill3.name;
            sk3_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               skill.style.display="none";
               turn=1;
               count=0;
               num=3;
            });
            sk3_2.addEventListener("mouseover",(event) => {
               sk3_1.style.display="block";
               select.innerHTML = "기술타입 /"+uskill1.type;
            });
            sk3_2.addEventListener("mouseout",(event) => {
               sk3_1.style.display="none";
               select.innerHTML = "";
            });
            sk4_2.innerHTML=uskill4.name;
            sk4_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               skill.style.display="none";
               turn=1;
               count=0;
               num=4;
            });
            sk4_2.addEventListener("mouseover",(event) => {
               sk4_1.style.display="block";
               select.innerHTML = "기술타입 /"+uskill1.type;
            });
            sk4_2.addEventListener("mouseout",(event) => {
               sk4_1.style.display="none";
               select.innerHTML = "";
            });
            sk1.appendChild(sk1_1);
            sk1.appendChild(sk1_2);
            sk2.appendChild(sk2_1);
            sk2.appendChild(sk2_2);
            sk3.appendChild(sk3_1);
            sk3.appendChild(sk3_2);
            sk4.appendChild(sk4_1);
            sk4.appendChild(sk4_2);
            
            skill.appendChild(sk1);
            skill.appendChild(sk2);
            skill.appendChild(sk3);
            skill.appendChild(sk4);
            

            skillBox.appendChild(skill);
            skillBox.style.display="block";
            
         });
         
         invenCur = document.createElement("div");
         invenCur.setAttribute("id","invenCur");
         invenCur.style.float ="right";
         invenCur.innerHTML="▶";
         invenCur.style.display="none"
         
         inven = document.createElement("div");
         inven.setAttribute("id","inven");
         inven.style.float ="right";
         inven.innerHTML="가방";
         inven.addEventListener("mouseover",(event) => {
            invenCur.style.display="block";
         });
         inven.addEventListener("mouseout",(event) => {
            invenCur.style.display="none";
         });
         inven.addEventListener("click",(event) => {
            skillBox=document.getElementById("skillBox");
            skillBox.innerHTML="";
            sel.style.display = "none";
            item = document.createElement("table");
            it1 = document.createElement("tr");
            it1_1 = document.createElement("td");
            it1_2 = document.createElement("td");
            it1_3 = document.createElement("td");
            it1_1.innerHTML="▶";
            it1_2.innerHTML="상처약";
            it1_3.innerHTML="X"+itemCou;
            
            it1_1.style.display="none";
            
            it1_1.style.float = "left";
            it1_2.style.float = "left";
            it1_3.style.float = "right";
            if(itemCou>0){it1_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               item.style.display="none";
               itemCou--;
               count=0;
               turn=3;
   
            });
            }
            it1_2.addEventListener("mouseover",(event) => {
               it1_1.style.display="block";
               select.innerHTML = "체력을 20 회복시킨다.";
            });
            it1_2.addEventListener("mouseout",(event) => {
               it1_1.style.display="none";
               select.innerHTML = "";
            });
            
            it1.appendChild(it1_1);
            it1.appendChild(it1_2);
            it1.appendChild(it1_3);
            item.appendChild(it1);
            skillBox.appendChild(item);
            
            skillBox.style.display="block";
         });
         
         
         poketCur = document.createElement("div");
         poketCur.setAttribute("id","poketCur");
         poketCur.style.float ="left";
         poketCur.innerHTML="▶";
         poketCur.style.display="none"
         
         poket = document.createElement("div");
         poket.setAttribute("id","poket");
         poket.style.float ="left";
         poket.innerHTML=" 포켓몬";
         poket.addEventListener("mouseover",(event) => {
            poketCur.style.display="block";
         });
         poket.addEventListener("mouseout",(event) => {
            poketCur.style.display="none";
         });
         poket.addEventListener("click",(event) => {
            skillBox=document.getElementById("skillBox");
            skillBox.innerHTML="";
            sel.style.display = "none";
            poke = document.createElement("table");
            
            pk1 = document.createElement("tr");
            pk1_1 = document.createElement("td");
            pk1_2 = document.createElement("td");
            pk1_1.style.float="left";
            pk1_2.style.float="left";
            pk1_1.innerHTML="▶";
            pk1_1.style.display="none";
            pk1_2.innerHTML=uPokemon1.name;
            pk1_2.addEventListener("mouseover",(event) => {
               pk1_1.style.display="block";
               if(alive1){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk1_2.addEventListener("mouseout",(event) => {
               pk1_1.style.display="none";
               select.innerHTML = "";
            });
            if(alive1 && uPokemon.id != uPokemon1.id){pk1_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=1;
               count=0;
               turn=4;
               
            });
            }
            
            pk2 = document.createElement("tr");
            pk2_1 = document.createElement("td");
            pk2_2 = document.createElement("td");
            pk2_1.innerHTML="▶";
            pk2_1.style.display="none";
            pk2_1.style.float="left";
            pk2_2.style.float="left";
            pk2_2.innerHTML="<%=pocketmon2.getName()%>";
            pk2_2.addEventListener("mouseover",(event) => {
               pk2_1.style.display="block";
               if(alive2){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk2_2.addEventListener("mouseout",(event) => {
               pk2_1.style.display="none";
            });
            if(alive2 && uPokemon.id != uPokemon2.id){pk2_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=2;
               count=0;
               turn=4;
               
            });
            }

            pk3 = document.createElement("tr");
            pk3_1 = document.createElement("td");
            pk3_2 = document.createElement("td");
            pk3_1.innerHTML="▶";
            pk3_1.style.display="none";
            pk3_1.style.float="left";
            pk3_2.style.float="left";
            pk3_2.innerHTML="<%=pocketmon3.getName()%>";
            pk3_2.addEventListener("mouseover",(event) => {
               pk3_1.style.display="block";
               if(alive3){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk3_2.addEventListener("mouseout",(event) => {
               pk3_1.style.display="none";
            });
            if(alive3  && uPokemon.id != uPokemon3.id){pk3_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=3;
               count=0;
               turn=4;
               
            });
            }
            
            pk1.appendChild(pk1_1);
            pk1.appendChild(pk1_2);
            pk2.appendChild(pk2_1);
            pk2.appendChild(pk2_2);
            pk3.appendChild(pk3_1);
            pk3.appendChild(pk3_2);
            
            poke.appendChild(pk1);
            poke.appendChild(pk2);
            poke.appendChild(pk3);
            
            skillBox.appendChild(poke);
            skillBox.style.display="block";
   
         });
         
         runCur = document.createElement("div");
         runCur.setAttribute("id","runCur");
         runCur.style.float ="right";
         runCur.innerHTML="▶";
         runCur.style.display="none"
         
         run = document.createElement("div");
         run.setAttribute("id","run");
         run.style.float ="right";
         run.style.fontSize="60px";
         run.innerHTML="도망치다";
         run.addEventListener("mouseover",(event) => {
            runCur.style.display="block";
         });
         run.addEventListener("mouseout",(event) => {
            runCur.style.display="none";
         });
         run.addEventListener("click",(event) => {
        	 turn=10;
        	 count=0;
         });
         
         
         tr1.appendChild(battleCur);
         tr1.appendChild(battle);
         tr1.appendChild(inven);
         tr1.appendChild(invenCur);
         tr2.appendChild(poketCur);
         tr2.appendChild(poket);
         tr2.appendChild(run);
         tr2.appendChild(runCur);
         
         sel.appendChild(tr1);
         sel.appendChild(tr2);
         
         select.appendChild(sel);
         
         textBox = document.getElementById("textBox");
         textBox.appendChild(select);
         
         
      }
      
      if(turn==3){
         setType();

         if(count==1){
            textBox.innerHTML ="Player는 상쳐약을 썻다!";
         }
         
         var maxHealth;
         if(pNum==1){maxHealth=<%=pocketmon1.getHP()%>;}
         else if(pNum==2){maxHealth=<%=pocketmon2.getHP()%>;}
         else if(pNum==3){maxHealth=<%=pocketmon3.getHP()%>;}
         if(count==2){	
            var hp = uh/100*uPokemon.health + 20; 
            uh = hp/maxHealth*100;
            if(uh>100){uh=100; hp=maxHealth}
            document.getElementById("uh").style.width =uh+"%";
            
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
         }
            
         
         rans = Math.floor(Math.random() * 4);
         if(rans==0){var sk = eskill1;}
         else if(rans==1){var sk = eskill2;}
         else if(rans==2){var sk = eskill3;}
         else if(rans==3){var sk = eskill4;}   
         if(count==3){
            textBox.innerHTML =ePokemon.name+"의 "+sk.name+"!";
         }
         
         acc = Math.floor(Math.random() * 101);
         if(sk.accuracy < acc && count==4)
            textBox.innerHTML = "그러나 "+ePokemon+"의 공격은 빗나갔다!";
         else if(sk.accuracy >= acc && count==4 && uType.weak.includes(sk.type)){
            var hp = uh/100*uPokemon.health - ((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)*1.5;
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 굉장했다!";
         }
         else if(sk.accuracy >= acc && count==4 && uType.strong.includes(sk.type)){
            var hp = uh/100*uPokemon.health - ((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)/2;
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 별로다";
         }
         else if(sk.accuracy >= acc && count==3 ){
             var hp = uh/100*uPokemon.health -((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2);
             if(hp<=0){hp=0;count=0;turn=6;}
             uh = hp/maxHealth*100;
             document.getElementById("uh").style.width =uh+"%";
             document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+uPokemon.health; 
          }
         if(count==4)
            turn =2;
      }
      
      if(turn==4){
         if(count==1){
            textBox.innerHTML =uPokemon.name+" 교대! 돌아와!";
            if(uPokemon.id == <%=pocketmon1.getId()%>){uPokemon1.health=Math.round(uh/100*uPokemon.health);}
            else if(uPokemon.id == <%=pocketmon2.getId()%>){uPokemon2.health=Math.round(uh/100*uPokemon.health);}
            else if(uPokemon.id == <%=pocketmon3.getId()%>){uPokemon3.health=Math.round(uh/100*uPokemon.health);}
         }
         var temp = 0;
 
         
         var maxHealth;
         if(pNum==1){uPokemon = uPokemon1; uh= uPokemon.health/<%=pocketmon1.getHP()%>*100;
         maxHealth=<%=pocketmon1.getHP()%>;
         uskill1 =new Skill(<%=skill1[0].getNum()%>,"<%=skill1[0].getSkillName()%>","<%=skill1[0].getProperty()%>",
         <%=skill1[0].getPower()%>,<%=skill1[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill1[1].getNum()%>,"<%=skill1[1].getSkillName()%>","<%=skill1[1].getProperty()%>",
         <%=skill1[1].getPower()%>,<%=skill1[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill1[2].getNum()%>,"<%=skill1[2].getSkillName()%>","<%=skill1[2].getProperty()%>",
         <%=skill1[2].getPower()%>,<%=skill1[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill1[3].getNum()%>,"<%=skill1[3].getSkillName()%>","<%=skill1[3].getProperty()%>",
         <%=skill1[3].getPower()%>,<%=skill1[3].getAccuracy()%>);
         }
         else if(pNum==2){uPokemon = uPokemon2;uh= uPokemon.health/<%=pocketmon2.getHP()%>*100;
         maxHealth=<%=pocketmon2.getHP()%>;
         uskill1 =new Skill(<%=skill2[0].getNum()%>,"<%=skill2[0].getSkillName()%>","<%=skill2[0].getProperty()%>",
         <%=skill2[0].getPower()%>,<%=skill2[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill2[1].getNum()%>,"<%=skill2[1].getSkillName()%>","<%=skill2[1].getProperty()%>",
         <%=skill2[1].getPower()%>,<%=skill2[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill2[2].getNum()%>,"<%=skill2[2].getSkillName()%>","<%=skill2[2].getProperty()%>",
         <%=skill2[2].getPower()%>,<%=skill2[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill2[3].getNum()%>,"<%=skill2[3].getSkillName()%>","<%=skill2[3].getProperty()%>",
         <%=skill2[3].getPower()%>,<%=skill2[3].getAccuracy()%>);
         }
         else if(pNum==3){uPokemon = uPokemon3;uh= uPokemon.health/<%=pocketmon3.getHP()%>*100;
         maxHealth=<%=pocketmon3.getHP()%>;
         uskill1 =new Skill(<%=skill3[0].getNum()%>,"<%=skill3[0].getSkillName()%>","<%=skill3[0].getProperty()%>",
         <%=skill3[0].getPower()%>,<%=skill3[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill1[1].getNum()%>,"<%=skill3[1].getSkillName()%>","<%=skill3[1].getProperty()%>",
         <%=skill3[1].getPower()%>,<%=skill3[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill1[2].getNum()%>,"<%=skill3[2].getSkillName()%>","<%=skill3[2].getProperty()%>",
         <%=skill3[2].getPower()%>,<%=skill3[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill1[3].getNum()%>,"<%=skill3[3].getSkillName()%>","<%=skill3[3].getProperty()%>",
         <%=skill3[3].getPower()%>,<%=skill3[3].getAccuracy()%>);
         }
         if(count==2){
            textBox.innerHTML ="가랏! "+uPokemon.name+"!";
            
            const userPoket=document.createElement("img");
            userPoket.src="img/"+uPokemon.id+"b.png";
            userPoket.style.width="300px";
            userPoket.style.height="300px";
            var ani2=document.getElementById("ani2");
            ani2.innerHTML="";
            ani2.appendChild(userPoket);
            
            var userHealth=document.getElementById("userHealth");
            document.getElementById("uPokemonName").innerHTML = uPokemon.name+":L60"; 
            document.getElementById("uPokemonHp").innerHTML = uPokemon.health+"/"+maxHealth; 
            userHealth.style.display="block";
            
            document.getElementById("uh").style.width =uh+"%";
         }
         setType();

         rans = Math.floor(Math.random() * 4);
         if(rans==0){var sk = eskill1;}
         else if(rans==1){var sk = eskill2;}
         else if(rans==2){var sk = eskill3;}
         else if(rans==3){var sk = eskill4;}   
         if(count==3){
            textBox.innerHTML =ePokemon.name+"의 "+sk.name+"!";
         }
         
         acc = Math.floor(Math.random() * 101);
         if(sk.accuracy < acc && count==4)
            textBox.innerHTML = "그러나 "+ePokemon.name+"의 공격은 빗나갔다!";
         else if(sk.accuracy >= acc && count==4 && uType.weak.includes(sk.type)){
            var hp = uh/100*uPokemon.health -((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)*1.5;
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 굉장했다!";
         }
         else if(sk.accuracy >= acc && count==4 && uType.strong.includes(sk.type)){
            var hp = uh/100*uPokemon.health -((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2)/2;
            if(hp<=0){hp=0;count=0;turn=6;}
            uh = hp/maxHealth*100;
            document.getElementById("uh").style.width =uh+"%";
            document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
            textBox.innerHTML = "효과가 별로다";
         }
         else if(sk.accuracy >= acc && count==3 ){
             var hp = uh/100*uPokemon.health -((ePokemon.damage * sk.damage * 13)/uPokemon.defense/50+2);
             if(hp<=0){hp=0;count=0;turn=6;}
             uh = hp/maxHealth*100;
             document.getElementById("uh").style.width =uh+"%";
             document.getElementById("uPokemonHp").innerHTML = Math.round(hp)+"/"+maxHealth; 
          }
         
         if(count==4)
            turn =2;
         
      }
      if(turn==5){
         if(count==1){
            textBox.innerHTML="적의 "+ePokemon.name+"은(는) 쓰러졌다!";
         }
         if(count == 2){
            if(ePokemon.id==<%=randPocketmon[0].getId()%>){
               ePokemon = new Pokemon(<%=randPocketmon[1].getId()%>,"<%=randPocketmon[1].getName()%>","<%=randPocketmon[1].getProperty()%>",
                     <%=randPocketmon[1].getSTR()%>,<%=randPocketmon[1].getDEX()%>,<%=randPocketmon[1].getHP()%>);
               eskill1 =new Skill(<%=eSkill2[0].getNum()%>,"<%=eSkill2[0].getSkillName()%>","<%=eSkill2[0].getProperty()%>",
            	         <%=eSkill2[0].getPower()%>,<%=eSkill2[0].getAccuracy()%>);
               eskill2 =new Skill(<%=eSkill2[1].getNum()%>,"<%=eSkill2[1].getSkillName()%>","<%=eSkill2[1].getProperty()%>",
            	         <%=eSkill2[1].getPower()%>,<%=eSkill2[1].getAccuracy()%>);
               eskill3 =new Skill(<%=eSkill2[2].getNum()%>,"<%=eSkill2[2].getSkillName()%>","<%=eSkill2[2].getProperty()%>",
            	         <%=eSkill2[2].getPower()%>,<%=eSkill2[2].getAccuracy()%>);
               eskill4 =new Skill(<%=eSkill2[3].getNum()%>,"<%=eSkill2[3].getSkillName()%>","<%=eSkill2[3].getProperty()%>",
            	         <%=eSkill2[3].getPower()%>,<%=eSkill2[3].getAccuracy()%>);
            }
            else if(ePokemon.id==<%=randPocketmon[1].getId()%>){
               ePokemon = new Pokemon(<%=randPocketmon[2].getId()%>,"<%=randPocketmon[2].getName()%>","<%=randPocketmon[2].getProperty()%>",
                     <%=randPocketmon[2].getSTR()%>,<%=randPocketmon[2].getDEX()%>,<%=randPocketmon[2].getHP()%>);
               eskill1 =new Skill(<%=eSkill3[0].getNum()%>,"<%=eSkill3[0].getSkillName()%>","<%=eSkill3[0].getProperty()%>",
          	         <%=eSkill3[0].getPower()%>,<%=eSkill3[0].getAccuracy()%>);
             eskill2 =new Skill(<%=eSkill3[1].getNum()%>,"<%=eSkill3[1].getSkillName()%>","<%=eSkill3[1].getProperty()%>",
          	         <%=eSkill3[1].getPower()%>,<%=eSkill3[1].getAccuracy()%>);
             eskill3 =new Skill(<%=eSkill3[2].getNum()%>,"<%=eSkill3[2].getSkillName()%>","<%=eSkill3[2].getProperty()%>",
          	         <%=eSkill3[2].getPower()%>,<%=eSkill3[2].getAccuracy()%>);
             eskill4 =new Skill(<%=eSkill3[3].getNum()%>,"<%=eSkill3[3].getSkillName()%>","<%=eSkill3[3].getProperty()%>",
          	         <%=eSkill3[3].getPower()%>,<%=eSkill3[3].getAccuracy()%>);
            }
            else if(ePokemon.id==<%=randPocketmon[2].getId()%>){
               turn=8;
               count=0;
            }
         }
         
         if(count==3){

            textBox.innerHTML="곤충소년은(는) "+ePokemon.name+ "를(을) 차례로 꺼냈다.";
            
            const enumyPoket=document.createElement("img");
            enumyPoket.src="img/"+ePokemon.id+"f.png";
            enumyPoket.style.width="300px";
            enumyPoket.style.height="300px";
            var ani1=document.getElementById("ani1");
            ani1.innerHTML="";
            ani1.appendChild(enumyPoket);
            
            var enumyHealth=document.getElementById("enumyHealth");
            document.getElementById("ePokemonName").innerHTML = ePokemon.name+":L60"; 
            enumyHealth.style.display="block";
            
            document.getElementById("eh").style.width =100+"%";
         }
         if(count==3){
            turn=2; count=0;
         }
      }
      if(turn==6){
         if(count==1){
            if(uPokemon.id == uPokemon1.id){alive1=false;}
            else if(uPokemon.id == uPokemon2.id){alive2=false;}
            else if(uPokemon.id == uPokemon3.id){alive3=false;}
            textBox.innerHTML=uPokemon.name+"은(는) 힘을 다했다!";
         }
         if(!alive1 && !alive2 && !alive3 && count==2)
    		 turn = 9;
         else if(count==2){
            textBox.innerHTML="";
            skillBox=document.getElementById("skillBox");
            skillBox.innerHTML="";
            poke = document.createElement("table");
            
            pk1 = document.createElement("tr");
            pk1_1 = document.createElement("td");
            pk1_2 = document.createElement("td");
            pk1_1.style.float="left";
            pk1_2.style.float="left";
            pk1_1.innerHTML="▶";
            pk1_1.style.display="none";
            pk1_2.innerHTML=uPokemon1.name;
            pk1_2.addEventListener("mouseover",(event) => {
               pk1_1.style.display="block";
               if(alive1){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk1_2.addEventListener("mouseout",(event) => {
               pk1_1.style.display="none";
               select.innerHTML = "";
            });
            if(alive1 && uPokemon.id != uPokemon1.id){pk1_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=1;
               count=0;
               turn=7;
               
            });
            }
            
            pk2 = document.createElement("tr");
            pk2_1 = document.createElement("td");
            pk2_2 = document.createElement("td");
            pk2_1.innerHTML="▶";
            pk2_1.style.display="none";
            pk2_1.style.float="left";
            pk2_2.style.float="left";
            pk2_2.innerHTML="<%=pocketmon2.getName()%>";
            pk2_2.addEventListener("mouseover",(event) => {
               pk2_1.style.display="block";
               if(alive2){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk2_2.addEventListener("mouseout",(event) => {
               pk2_1.style.display="none";
            });
            if(alive2 && uPokemon.id != uPokemon2.id){pk2_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=2;
               count=0;
               turn=7;
               
            });
            }

            pk3 = document.createElement("tr");
            pk3_1 = document.createElement("td");
            pk3_2 = document.createElement("td");
            pk3_1.innerHTML="▶";
            pk3_1.style.display="none";
            pk3_1.style.float="left";
            pk3_2.style.float="left";
            pk3_2.innerHTML="<%=pocketmon3.getName()%>";
            pk3_2.addEventListener("mouseover",(event) => {
               pk3_1.style.display="block";
               if(alive3){select.innerHTML = "출전가능";}
               else{select.innerHTML = "출전불가능";}
            });
            pk3_2.addEventListener("mouseout",(event) => {
               pk3_1.style.display="none";
            });
            if(alive3  && uPokemon.id != uPokemon3.id){pk3_2.addEventListener("click",(event) => {
               skillBox.style.display="none";
               select.style.display="none";
               poke.style.display="none";
               pNum=3;
               count=0;
               turn=7;
               
            });
            }

            pk1.appendChild(pk1_1);
            pk1.appendChild(pk1_2);
            pk2.appendChild(pk2_1);
            pk2.appendChild(pk2_2);
            pk3.appendChild(pk3_1);
            pk3.appendChild(pk3_2);
            
            poke.appendChild(pk1);
            poke.appendChild(pk2);
            poke.appendChild(pk3);
            
            skillBox.appendChild(poke);
            skillBox.style.display="block";
            
         }
      }
      if(turn==7){
         if(count==1){
            textBox.innerHTML =uPokemon.name+" 교대! 돌아와!";
            if(uPokemon.id == <%=pocketmon1.getId()%>){uPokemon1.health=Math.round(uh/100*uPokemon.health); }
            else if(uPokemon.id == <%=pocketmon2.getId()%>){uPokemon2.health=Math.round(uh/100*uPokemon.health);}
            else if(uPokemon.id == <%=pocketmon3.getId()%>){uPokemon3.health=Math.round(uh/100*uPokemon.health);}
         }
         var temp = 0;
         
         var maxHealth;
         if(pNum==1){uPokemon = uPokemon1; uh= uPokemon.health/<%=pocketmon1.getHP()%>*100;
         maxHealth=<%=pocketmon1.getHP()%>;
         uskill1 =new Skill(<%=skill1[0].getNum()%>,"<%=skill1[0].getSkillName()%>","<%=skill1[0].getProperty()%>",
         <%=skill1[0].getPower()%>,<%=skill1[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill1[1].getNum()%>,"<%=skill1[1].getSkillName()%>","<%=skill1[1].getProperty()%>",
         <%=skill1[1].getPower()%>,<%=skill1[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill1[2].getNum()%>,"<%=skill1[2].getSkillName()%>","<%=skill1[2].getProperty()%>",
         <%=skill1[2].getPower()%>,<%=skill1[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill1[3].getNum()%>,"<%=skill1[3].getSkillName()%>","<%=skill1[3].getProperty()%>",
         <%=skill1[3].getPower()%>,<%=skill1[3].getAccuracy()%>);
         }
         else if(pNum==2){uPokemon = uPokemon2;uh= uPokemon.health/<%=pocketmon2.getHP()%>*100;
         maxHealth=<%=pocketmon2.getHP()%>;
         uskill1 =new Skill(<%=skill2[0].getNum()%>,"<%=skill2[0].getSkillName()%>","<%=skill2[0].getProperty()%>",
         <%=skill2[0].getPower()%>,<%=skill2[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill2[1].getNum()%>,"<%=skill2[1].getSkillName()%>","<%=skill2[1].getProperty()%>",
         <%=skill2[1].getPower()%>,<%=skill2[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill2[2].getNum()%>,"<%=skill2[2].getSkillName()%>","<%=skill2[2].getProperty()%>",
         <%=skill2[2].getPower()%>,<%=skill2[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill2[3].getNum()%>,"<%=skill2[3].getSkillName()%>","<%=skill2[3].getProperty()%>",
         <%=skill2[3].getPower()%>,<%=skill2[3].getAccuracy()%>);
         }
         else if(pNum==3){uPokemon = uPokemon3;uh= uPokemon.health/<%=pocketmon3.getHP()%>*100;
         maxHealth=<%=pocketmon3.getHP()%>;
         uskill1 =new Skill(<%=skill3[0].getNum()%>,"<%=skill3[0].getSkillName()%>","<%=skill3[0].getProperty()%>",
         <%=skill3[0].getPower()%>,<%=skill3[0].getAccuracy()%>);
         uskill2 =new Skill(<%=skill3[1].getNum()%>,"<%=skill3[1].getSkillName()%>","<%=skill3[1].getProperty()%>",
         <%=skill3[1].getPower()%>,<%=skill3[1].getAccuracy()%>);
         uskill3 =new Skill(<%=skill3[2].getNum()%>,"<%=skill3[2].getSkillName()%>","<%=skill3[2].getProperty()%>",
         <%=skill3[2].getPower()%>,<%=skill3[2].getAccuracy()%>);
         uskill4 =new Skill(<%=skill3[3].getNum()%>,"<%=skill3[3].getSkillName()%>","<%=skill3[3].getProperty()%>",
         <%=skill3[3].getPower()%>,<%=skill3[3].getAccuracy()%>);
         }
         if(count==2){
            textBox.innerHTML ="가랏! "+uPokemon.name+"!";
            
            const userPoket=document.createElement("img");
            userPoket.src="img/"+uPokemon.id+"b.png";
            userPoket.style.width="300px";
            userPoket.style.height="300px";
            var ani2=document.getElementById("ani2");
            ani2.innerHTML="";
            ani2.appendChild(userPoket);
            
            var userHealth=document.getElementById("userHealth");
            document.getElementById("uPokemonName").innerHTML = uPokemon.name+":L60"; 
            document.getElementById("uPokemonHp").innerHTML = uPokemon.health+"/"+maxHealth; 
            userHealth.style.display="block";
            
            document.getElementById("uh").style.width =uh+"%";
         }
      
         if(count==3)
            turn =2;
         
      }
      if(turn==8){
         if(count==1){
            textBox.innerHTML ="적 "+ePokemon.name+"는(은) 쓰러졌다!";
         }
         if(count==2){
            textBox.innerHTML ="Player는 곤충소년와(과)의 승부에서 이겼다!";
         }
         if(count==3){
            const enumyPoket=document.createElement("img");
            enumyPoket.src="img/enumy1.png";
            enumyPoket.style.width="300px";
            enumyPoket.style.height="300px";
            var ani1=document.getElementById("ani1");
            ani1.innerHTML="";
            ani1.appendChild(enumyPoket);
            
            var enumyHealth=document.getElementById("enumyHealth");
            enumyHealth.style.display="none";
            
         }
         if(count==4){
        	 location.replace("PocketMon_Select.html");
         }
      }
      if(turn==9){
    	  if(count==1){
              textBox.innerHTML ="Player의 "+uPokemon.name+"는(은) 쓰러졌다!";
           }
           if(count==2){
              textBox.innerHTML ="Player는 곤충소년와(과)의 승부에서 패배했다!";
           }
           if(count==3){
              const uesrPoket=document.createElement("img");
              uesrPoket.src="img/user1.png";
              uesrPoket.style.width="300px";
              uesrPoket.style.height="300px";
              var ani2=document.getElementById("ani2");
              ani2.innerHTML="";
              ani2.appendChild(uesrPoket);
              
              var enumyHealth=document.getElementById("userHealth");
              enumyHealth.style.display="none";
              
           }
           if(count==4){
        	   location.replace("PocketMon_Select.html");
           }
      }
      if(turn==10){
    	  if(count==1){
              textBox.innerHTML ="Player가 도망친다"
           }
           if(count==2){
        	   location.replace("PocketMon_Select.html");
           }
      }
      
      
   }
   
   </script>
</body>
</html>