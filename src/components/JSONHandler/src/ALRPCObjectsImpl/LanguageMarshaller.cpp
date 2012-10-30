#include <cstring>
#include "../../include/JSONHandler/ALRPCObjects/Language.h"
#include "LanguageMarshaller.h"
#include "LanguageMarshaller.inc"


/*
  interface	Ford Sync RAPI
  version	1.2
  date		2011-05-17
  generated at	Tue Oct 30 08:29:32 2012
  source stamp	Thu Oct 25 06:49:27 2012
  author	robok0der
*/



const Language::LanguageInternal LanguageMarshaller::getIndex(const char* s)
{
  if(!s)
    return Language::INVALID_ENUM;
  const struct PerfectHashTable* p=Language_intHash::getPointer(s,strlen(s));
  return p ? static_cast<Language::LanguageInternal>(p->idx) : Language::INVALID_ENUM;
}


bool LanguageMarshaller::fromJSON(const Json::Value& s,Language& e)
{
  e.mInternal=Language::INVALID_ENUM;
  if(!s.isString())
    return false;

  e.mInternal=getIndex(s.asString().c_str());
  return (e.mInternal!=Language::INVALID_ENUM);
}


Json::Value LanguageMarshaller::toJSON(const Language& e)
{
  if(e.mInternal==Language::INVALID_ENUM) 
    return Json::Value(Json::nullValue);
  const char* s=getName(e.mInternal);
  return s ? Json::Value(s) : Json::Value(Json::nullValue);
}


bool LanguageMarshaller::fromString(const std::string& s,Language& e)
{
  e.mInternal=Language::INVALID_ENUM;
  try
  {
    Json::Reader reader;
    Json::Value json;
    if(!reader.parse(s,json,false))  return false;
    if(fromJSON(json,e))  return true;
  }
  catch(...)
  {
    return false;
  }
  return false;
}

const std::string LanguageMarshaller::toString(const Language& e)
{
  Json::FastWriter writer;
  return e.mInternal==Language::INVALID_ENUM ? "" : writer.write(toJSON(e));

}

const PerfectHashTable LanguageMarshaller::mHashTable[3]=
{
  {"EN-US",0},
  {"ES-MX",1},
  {"FR-CA",2}
};
