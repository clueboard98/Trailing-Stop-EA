#include <Trade/Trade.mqh>
CTrade obj_trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   obj_trade.SetExpertMagicNumber(123);

   // TO OPEN TEST POSTIONS
   for (int i = 0; i < 3; i++){
      int ticketBuy = obj_trade.Buy(0.01);
      if (ticketBuy > 0){
         for (int j = 0; j < 1; j++){
            obj_trade.Sell(0.01);
         }
      }
   }
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   applyTrailingSTOP(123,300*_Point);
  }
//+------------------------------------------------------------------+

void applyTrailingSTOP(int magicNo, double slPoints){
   // use the forloop to iterate via all the open positions
   double buySL = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID)-slPoints,_Digits);
   double sellSL = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK)+slPoints,_Digits);

   for (int i = PositionsTotal() - 1; i >= 0; i--){
      ulong ticket = PositionGetTicket(i);
      if (ticket > 0){
         if (PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_MAGIC) == magicNo){
            if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY &&
               buySL > PositionGetDouble(POSITION_PRICE_OPEN) &&
               (buySL > PositionGetDouble(POSITION_SL) ||
                              PositionGetDouble(POSITION_SL) == 0)){
               obj_trade.PositionModify(ticket,sellSL,PositionGetDouble(POSITION_TP));
            }
         }
      }
   }
}
