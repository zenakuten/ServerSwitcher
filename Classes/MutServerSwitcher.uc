class MutServerSwitcher extends Mutator config;

var config int SwitchTime;
var config string NewServer, NewServerPort;
var ServerQueryClient SQC;
var GameInfo.ServerResponseLine SRL;
var float LastPingTime;
var config float PingTime;
var bool bPingInProgress;

event PostBeginPlay()
{
    SetTimer(SwitchTime, true);
    if(Level != none)
    {
        SQC = Level.Spawn(class'ServerQueryClient');
        if(SQC != None)
        {
            SQC.OnReceivedPingInfo = ReceivedPingInfo;
            SQC.OnPingTimeout = ReceivedPingTimeout;
        }
    }

    Super.PostBeginPlay();
}

function bool MutatorIsAllowed()
{
    return true;
}

function ReceivedPingInfo( int listid, ServerQueryClient.EPingCause PingCause, GameInfo.ServerResponseLine s )
{
    SRL=s;
    bPingInProgress=false;
}

function ReceivedPingTimeout( int listid, ServerQueryClient.EPingCause PingCause  )
{
    bPingInProgress=false;
}


function GetServerDetails(out GameInfo.ServerResponseLine ServerState)
{
    //set our server state to the same as the new server so it appears players are on
    //ServerState = SRL;
    if(SRL.CurrentPlayers > 0)
    {
        ServerState.CurrentPlayers = SRL.CurrentPlayers;
        ServerState.MaxPlayers = SRL.MaxPlayers;
        ServerState.MapName = SRL.MapName;
        ServerState.GameType = SRL.GameType;
        Serverstate.Ping = SRL.Ping;
    }
}

function GetServerPlayers(out GameInfo.ServerResponseLine ServerState)
{
    local int i;
    if(SRL.CurrentPlayers > 0)
    {
        ServerState.PlayerInfo.Length = SRL.PlayerInfo.Length+1;
        for(i=0;i<SRL.PlayerInfo.Length;i++)
        {
            ServerState.PlayerInfo[i].PlayerNum = SRL.PlayerInfo[i].PlayerNum;
            ServerState.PlayerInfo[i].PlayerName = SRL.PlayerInfo[i].PlayerName;
            ServerState.PlayerInfo[i].Ping = SRL.PlayerInfo[i].Ping;
            ServerState.PlayerInfo[i].Score = SRL.PlayerInfo[i].Score;
            ServerState.PlayerInfo[i].StatsID = SRL.PlayerInfo[i].StatsID;
        }
    }
}

event Timer() {
    local Controller C;
    local PlayerController PC;

    for( C = Level.ControllerList; C != None; C = C.NextController ){
        PC = PlayerController(C);
        if (PC == none) continue;
    
            PC.ClientTravel(NewServer$":"$NewServerPort, TRAVEL_Absolute, false);
    }

    //ping the new server every PingTime
    if(SQC != None && (LastPingTime < Level.TimeSeconds) && !bPingInProgress)
    {
        bPingInProgress=true;
        SQC.PingServer(0, PC_Clicked, NewServer, int(NewServerPort)+1, QI_RulesAndPlayers, SRL);
        LastPingTime = Level.TimeSeconds + PingTime;
    }
}


defaultproperties
{
    FriendlyName="ServerSwitcher"
    Description="Send to other server."
    SwitchTime=5
    NewServer="127.0.0.1"
    NewServerPort="7777"
    PingTime=20
}
