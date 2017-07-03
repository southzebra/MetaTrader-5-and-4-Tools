//+------------------------------------------------------------------+
//|                                                   candleTime.mq5 |
//|                   Francesco Danti Copyright 2011, OracolTech.com |
//|                                       http://blog.oracoltech.com |
//|                                      email:     fdanti@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Francesco Danti Copyright 2011, OracolTech.com"
#property link      "http://blog.oracoltech.com"
#property version   "1.00"

#property indicator_chart_window

#property indicator_buffers 1
#property indicator_plots   1

string idxLabel="lblNextCandle";

input color lblColor=clrMediumSeaGreen;                    // Color of the label
input int fontSize=10;                                // Size of the label font
input ENUM_ANCHOR_POINT pAnchor = ANCHOR_LEFT_LOWER; // Anchor of the label a sort of align
input bool nextToPriceOrAnchor = true;               // Position near the price close or to Corner
input ENUM_BASE_CORNER pCorner = CORNER_LEFT_LOWER;  // Corner position of the label
input string fontFamily = "Arial";                  // Font family of the label
input bool clocktime = true;                  // Show clock time

datetime time0 = NULL;
double close0 = NULL;


int OnInit()
{
   EventSetTimer(1);
   return(0);
}


void OnDeinit(const int r)
{
   EventKillTimer();
   Comment("");
   ObjectDelete(0,idxLabel);
}


void OnTimer()
{
   if(time0!=NULL && close0!=NULL)
      Calculate();
}


int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   ArraySetAsSeries(time,true);
   ArraySetAsSeries(close,true);

   time0 = time[0];
   close0 = close[0];

   Calculate();

   return(rates_total);
}


void Calculate()
{
   int tS,iS,iM,iH;
   string sS,sM,sH;

   tS=(int) time0+PeriodSeconds() -(int) TimeCurrent();

   iS=tS%60;

   iM=(tS-iS);
   if(iM!=0) iM/=60;
   iM-=(iM-iM%60);

   iH=(tS-iS-iM*60);
   if(iH != 0) iH /= 60;
   if(iH != 0) iH /= 60;

   sS = IntegerToString(iS,1,'0');
   sM = IntegerToString(iM,1,'0');
   sH = IntegerToString(iH,1,'0');

   string cmt;
   cmt=sH+"h "+sM+"m "+sS+"s";
   if(iH==0)
   {
      cmt=sM+"m "+sS+"s";
      if(iM==0)
         cmt=sS+"s";
   }
   
   if(clocktime)
      cmt += " - " + TimeToString(time0+PeriodSeconds(),TIME_MINUTES);

   if(nextToPriceOrAnchor)
   {
      if(ObjectGetInteger(0,idxLabel,OBJPROP_TYPE)==OBJ_LABEL) ObjectDelete(0,idxLabel);
      ObjectCreate(0,idxLabel,OBJ_TEXT,0,time0+PeriodSeconds()*2,close0);
      ObjectSetInteger(0,idxLabel,OBJPROP_ANCHOR,pAnchor);
   }
   else
   {
      if(ObjectGetInteger(0,idxLabel,OBJPROP_TYPE)==OBJ_TEXT) ObjectDelete(0,idxLabel);
      ObjectCreate(0,idxLabel,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,idxLabel,OBJPROP_ANCHOR,pAnchor);
      ObjectSetInteger(0,idxLabel,OBJPROP_CORNER,pCorner);
   }

   ObjectSetInteger(0,idxLabel,OBJPROP_COLOR,lblColor);
   ObjectSetString(0,idxLabel,OBJPROP_TEXT,cmt);
   ObjectSetInteger(0,idxLabel,OBJPROP_FONTSIZE,fontSize);
   ObjectSetString(0,idxLabel,OBJPROP_FONT,fontFamily);

}
