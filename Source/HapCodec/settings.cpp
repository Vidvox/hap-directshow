#pragma once
#include "interface.h"
#include "hapcodec.h"
#include <commctrl.h>
#include <shellapi.h>
#include <Windowsx.h>
#include <intrin.h>

const char* g_settingNameUseSnappy = "UseSnappy";
const char* g_settingNameDxtQuality = "DXTQuality";
const char* g_settingNameGenBackground = "GenerateTransparencyBackground";

const char* kRootRegistryKey = "Software\\HapCodec";

void StoreRegistrySettings(bool useSnappy, int dxtQuality, bool generateTransparencyBackground)
{
	DWORD dp;
	HKEY regkey;
	const char * dxtQualityStrings[3] = {"HIGH", "GOOD", "LOW "};
	if ( RegCreateKeyEx(HKEY_CURRENT_USER,kRootRegistryKey,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&regkey,&dp) == ERROR_SUCCESS)
	{
		DWORD data = 0;
		if (useSnappy) data = 1; else data = 0;
		RegSetValueEx(regkey,g_settingNameUseSnappy,0,REG_DWORD,(unsigned char*)&data,4);
		if (generateTransparencyBackground) data = 1; else data = 0;
		RegSetValueEx(regkey,g_settingNameGenBackground,0,REG_DWORD,(unsigned char*)&data,4);
		RegSetValueEx(regkey,g_settingNameDxtQuality,0,REG_SZ,(unsigned char*)dxtQualityStrings[dxtQuality],4);
		RegCloseKey(regkey);
	}
}

void LoadRegistrySettings(bool* useSnappy, int* dxtQuality, bool* generateTransparencyBackground)
{
	HKEY regkey;
	unsigned char data[]={0,0,0,0,0,0,0,0};
	DWORD size=sizeof(data);
	if ( RegOpenKeyEx(HKEY_CURRENT_USER,kRootRegistryKey,0,KEY_READ,&regkey) == ERROR_SUCCESS)
	{
		if (useSnappy != NULL)
		{
			if (ERROR_SUCCESS == RegQueryValueEx(regkey,g_settingNameUseSnappy,0,NULL,data,&size))
			{
				*useSnappy = (data[0]>0);
				size=sizeof(data);
			}
		}
		if (dxtQuality != NULL)
		{
			if (ERROR_SUCCESS == RegQueryValueEx(regkey,g_settingNameDxtQuality,0,NULL,data,&size))
			{
				int cmp = *(int*)data;
				if ( cmp == 'HGIH' )
				{
					*dxtQuality=0;
				}
				else if ( cmp == 'DOOG')
				{
					*dxtQuality=1;
				}
				else if ( cmp == ' WOL')
				{
					*dxtQuality=2;
				}
				else 
				{
					*dxtQuality=1;
				}
				size=sizeof(data);
			}
		}
		if (generateTransparencyBackground != NULL)
		{
			if (ERROR_SUCCESS == RegQueryValueEx(regkey,g_settingNameGenBackground,0,NULL,data,&size))
			{
				*generateTransparencyBackground = (data[0]>0);
				size=sizeof(data);
			}
		}
		RegCloseKey(regkey);
	}
	else 
	{
		const char* appName = "settings";
		const char* iniFilename = "hapcodec.ini";

		bool snappy = GetPrivateProfileInt(appName, g_settingNameUseSnappy, true, iniFilename)>0;
		int dxtQ = GetPrivateProfileInt(appName, g_settingNameDxtQuality, 1, iniFilename);
		bool genBg = GetPrivateProfileInt(appName, g_settingNameGenBackground, false, iniFilename)>0;
		if (dxtQ < 0 || dxtQ >= 3)
		{
			dxtQ = 1;
		} 
		StoreRegistrySettings(snappy, dxtQ, genBg);
		if (useSnappy != NULL) *useSnappy = snappy;
		if (dxtQuality != NULL) *dxtQuality = dxtQ;
		if (generateTransparencyBackground != NULL) *generateTransparencyBackground = genBg;
	}
}