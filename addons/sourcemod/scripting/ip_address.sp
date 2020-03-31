#include <sourcemod>
#include <cstrike>
#include <geoip>

//每行代码结束需填写“;”
#pragma semicolon 1

//新语法
#pragma newdecls required

//定义插件信息
#define NAME 			"Check IP Country And City | 查看IP国家和城市"
#define AUTHOR 			"ZZH | 凌凌漆"
#define DESCRIPTION 	"Check IP Country And City | 查看IP国家和城市"	
#define	VERSION 		"1.0"
#define URL 			"https://steamcommunity.com/id/ChengChiHou/"

//插件信息
public Plugin myinfo =
{
	name			=	NAME,
	author			=	AUTHOR,
	description		=	DESCRIPTION,
	version			=	VERSION,
	url				=	URL
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_ip", Command_IPAddress);
}

public Action Command_IPAddress(int client, int args)
{
	if(IsValidClient(client, false, true, true, false))
	{
		PrintClientIPAddress(client);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void PrintClientIPAddress(int client)
{
	if(IsValidClient(client, false, true, true, false))
	{
		char ClientIP[16], country[64], city[64];

		GetClientIP(client, ClientIP, sizeof(ClientIP));

		GeoipCountry(ClientIP, country, sizeof(country));

		GeoipCity(ClientIP, city, sizeof(city));

		PrintToChat(client, "\x01玩家\x07%N\x01来自：\x04%s %s，IP地址为：%s", client, country, city, ClientIP);
	}
}

//有效玩家实体检测
stock bool IsValidClient(int client, bool AllowBot = true, bool AllowDeath = true, bool AllowSpectator = true, bool AllowReplay = true)
{
	if(client < 1 || client > MaxClients)
	{
		return false;
	}
	if(!IsClientConnected(client) || !IsClientInGame(client))
	{
		return false;
	}
	if(!AllowBot)
	{
		if (IsFakeClient(client))
		{
			return false;
		}
	}
	if(!AllowDeath)
	{
		if (!IsPlayerAlive(client))
		{
			return false;
		}
	}
	if(!AllowSpectator)
	{
		if(GetClientTeam(client) == CS_TEAM_SPECTATOR)
		{
			return false;
		}
	}
	if(!AllowReplay)
	{
		if(IsClientSourceTV(client) || IsClientReplay(client))
		{
			return false;
		}
	}
	return true;
}