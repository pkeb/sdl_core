#include "../../include/JSONHandler/ALRPCObjects/TTSChunk.h"
#include "TTSChunkMarshaller.h"
#include "SpeechCapabilitiesMarshaller.h"
/*
  interface	Ford Sync RAPI
  version	1.2
  date		2011-05-17
  generated at	Tue Oct 30 08:29:32 2012
  source stamp	Thu Oct 25 06:49:27 2012
  author	robok0der
*/



TTSChunk::TTSChunk(const TTSChunk& c)
{
  *this=c;
}


bool TTSChunk::checkIntegrity(void)
{
  return TTSChunkMarshaller::checkIntegrity(*this);
}


TTSChunk::TTSChunk(void)
{
}



bool TTSChunk::set_text(const std::string& text_)
{
  if(text_.length()>500)  return false;
  text=text_;
  return true;
}

bool TTSChunk::set_type(const SpeechCapabilities& type_)
{
  if(!SpeechCapabilitiesMarshaller::checkIntegrityConst(type_))   return false;
  type=type_;
  return true;
}




const std::string& TTSChunk::get_text(void) const 
{
  return text;
}


const SpeechCapabilities& TTSChunk::get_type(void) const 
{
  return type;
}


