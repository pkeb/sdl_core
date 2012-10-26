#include "JSONHandler/ShowMarshaller.h"
#include <json/value.h>
#include <json/reader.h>
#include <json/writer.h>
#include "ALRPCObjectsImpl/TextAlignmentMarshaller.h"

using namespace RPC2Communication;

bool ShowMarshaller::fromString(const std::string& s,Show& e)
{
  try
  {
    Json::Reader reader;
    Json::Value json;
    if(!reader.parse(s,json,false))  return false;
    if(!fromJSON(json,e))  return false;
  }
  catch(...)
  {
    return false;
  }
  return true;
}


const std::string ShowMarshaller::toString(const Show& e)
{
  Json::FastWriter writer;
  return writer.write(toJSON(e));
}


Json::Value ShowMarshaller::toJSON(const Show& e)
{  
  Json::Value json(Json::objectValue);
  
  json["jsonrpc"]=Json::Value("2.0");
  json["method"]=Json::Value("UI.Show");
  
  Json::Value j=Json::Value(Json::objectValue);
  if (!e.mMainField1.empty())
  {
    j["mainField1"] = e.mMainField1;  
  }
  if (!e.mMainField2.empty())
  {
    j["mainField2"] = e.mMainField2;  
  }

  if ( e.mAlignment )
  {
    j["aligment"] = TextAlignmentMarshaller::toJSON(*e.mAlignment);    
  }

  if (!e.mStatusBar.empty())  
  {
    j["statusBar"] = e.mStatusBar;  
  }
  
  if (!e.mMediaClock.empty())
  {
    j["mediaClock"] = e.mMediaClock;   
  }
  
  if (!e.mMediaTrack.empty())
  {
    j["mediaTrack"] = e.mMediaTrack;  
  } 
  
  json["params"]=j;

  json["id"] = e.getID();

  return json;
}


bool ShowMarshaller::fromJSON(const Json::Value& json,Show& c)
{
  try
  {
    if(!json.isObject())  return false;
    
    if(!json.isMember("jsonrpc"))  return false;

    if(!json.isMember("method") 
        || !json["method"].isString() )
        return false;
    if (json["method"].asString().compare("UI.Show"))  
        return false;

    if(!json.isMember("params"))  return false;
    Json::Value j=json["params"];
    if(!j.isObject())  return false;

    if(j.isMember("mainField1")){
      if (!j["mainField1"].isString())
        return false;
      c.mMainField1 = j["mainField1"].asString();
    }     

    if(j.isMember("mainField2"))
    {
      if (!j["mainField2"].isString())
        return false;
      c.mMainField2 = j["mainField2"].asString();
    }     

    if (j.isMember("alignment")) 
    {
      delete c.mAlignment;
      if (!TextAlignmentMarshaller::fromJSON(j["alignment"], *c.mAlignment)) return false;  
    }
    
    if(j.isMember("statusBar"))
    {
      if (!j["statusBar"].isString())
        return false;
      c.mStatusBar = j["statusBar"].asString();
    }     

    if(j.isMember("mediaClock"))
    {
      if (!j["mediaClock"].isString())
        return false;
      c.mMediaClock = j["mediaClock"].asString();
    }      

    if(j.isMember("mediaTrack"))
    {
      if (!j["mediaTrack"].isString())
        return false;
      c.mMediaTrack = j["mediaTrack"].asString();
    }   

    if(!json.isMember("id")) return false;

    c.setID( json["id"].asInt() );
  } 
  catch(...)
  {
    return false;
  }

  return true;
}
