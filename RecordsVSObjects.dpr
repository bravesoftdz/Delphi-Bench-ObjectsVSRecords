program RecordsVSObjects;

{
 *  Copyright (c) 2017 Enrique Fuentes aka. Turrican
 *
 *  This software is provided 'as-is', without any express or
 *  implied warranty. In no event will the authors be held
 *  liable for any damages arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute
 *  it freely, subject to the following restrictions:
 *
 *  1. The origin of this software must not be misrepresented;
 *     you must not claim that you wrote the original software.
 *     If you use this software in a product, an acknowledgment
 *     in the product documentation would be appreciated but
 *     is not required.
 *
 *  2. Altered source versions must be plainly marked as such,
 *     and must not be misrepresented as being the original software.
 *
 *  3. This notice may not be removed or altered from any
 *     source distribution.
}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Quick.Chrono,
  System.SysUtils,
  System.Generics.Collections,
  System.Contnrs;

type

  TSpriteRec = record
    fx : Integer;
    fy : Integer;
    procedure Read;
  end;

  PSpriteRec = ^TSpriteRec;

  TSpriteObj = class(TObject)
    private
      fx : Integer;
      fy : Integer;
    public
      procedure Read;
  end;

  TSpriteRecArray = array of TSpriteRec;
  TPSpriteRecArray = array of PSpriteRec;
  TSpriteRecObjArray = array of TSpriteObj;


procedure Cout(const Line : string);
begin
  Writeln(Line + #13#10'___________________'#13#10);
end;

{----------------------------------------------------------------------}
{                             BenchMarks                               }
{----------------------------------------------------------------------}

procedure TestArrayofRecords;
const
  iterations = 10000000;
var
  chrono : TChronometer;
  x : integer;
  spriterecarray : TSpriteRecArray;
  spriterec : TSpriteRec;
begin
  Randomize;
  Cout('Test ARRAY of RECORDS');
  Cout(SizeOf(TSpriteRec).ToString + ' Bytes per Record');
  Cout('1000000 iterations');
  Cout('Write single thread');
  chrono := TChronometer.Create;
  chrono.Start;
  Cout('WRITE TEST');
  SetLength(spriterecarray, iterations);
  for x := 0 to iterations do
  begin
    spriterecarray[x].fx := Random(iterations);
    spriterecarray[x].fy := Random(iterations);
  end;
  chrono.Stop;
  Cout('Write END.');
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ TEST');
  chrono.Reset;
  chrono.Start;
  for x := 0 to iterations do
  begin
    spriterecarray[x].Read;
  end;
  chrono.Stop;
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ END');
  chrono.Free;
end;

procedure TestArrayofRecordsPointers;
const
  iterations = 10000000;
var
  chrono : TChronometer;
  x : integer;
  spriterecarrayP : TPSpriteRecArray;
begin
  Randomize;
  Cout('Test ARRAY of POINTERS TO RECORDS');
  Cout(SizeOf(PSpriteRec).ToString + ' Bytes per Record');
  Cout('1000000 iterations');
  Cout('Write single thread');
  chrono := TChronometer.Create;
  chrono.Start;
  SetLength(spriterecarrayP, iterations);
  for x := 0 to iterations do
  begin
    New(spriterecarrayP[x]);
    spriterecarrayP[x].fx := Random(iterations);
    spriterecarrayP[x].fy := Random(iterations);
  end;
  chrono.Stop;
  Cout('Write END.');
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ TEST');
  chrono.Reset;
  chrono.Start;
  for x := 0 to iterations do
  begin
    spriterecarrayP[x].Read;
  end;
  chrono.Stop;
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ END');
  Cout('Freeing Heap');
  for x := 0 to iterations do Dispose(spriterecarrayP[x]);
  chrono.Free;
end;

procedure TestArrayofObjects;
const
  iterations = 10000000;
var
  chrono : TChronometer;
  x : integer;
  spriteobjarray : TSpriteRecObjArray;
  spriteobj : TSpriteObj;
begin
  Randomize;
  Cout('Test ARRAY of OBJECTS');
  Cout(SizeOf(TSpriteObj).ToString + ' Bytes per Object');
  Cout('1000000 iterations');
  Cout('Write single thread');
  chrono := TChronometer.Create;
  chrono.Start;
  SetLength(spriteobjarray, iterations);
  for x := 0 to iterations do
  begin
    spriteobjarray[x] := TSpriteObj.Create;
    spriteobjarray[x].fx := Random(iterations);
    spriteobjarray[x].fy := Random(iterations);
  end;
  chrono.Stop;
  Cout('Write END.');
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ TEST');
  chrono.Reset;
  chrono.Start;
  for x := 0 to iterations do
  begin
    spriteobjarray[x].Read;
  end;
  chrono.Stop;
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ END');
  Cout('Freeing Heap');
  for x := 0 to iterations do spriteobjarray[x].Free;
  chrono.Free;
end;

procedure TestGenericObjectList;
const
  iterations = 10000000;
var
  chrono : TChronometer;
  x : integer;
  spriteobjlist : TObjectList<TSpriteObj>;
  spriteobj : TSpriteObj;
begin
  Randomize;
  Cout('Test Generic List of <TSpriteObj>');
  Cout(SizeOf(TSpriteObj).ToString + ' Bytes per Object');
  Cout('1000000 iterations');
  Cout('Write single thread');
  chrono := TChronometer.Create;
  chrono.Start;
  spriteobjlist := TObjectList<TSpriteObj>.Create(True);
  for x := 0 to iterations do
  begin
    spriteobj := TSpriteObj.Create;
    spriteobj.fx := Random(iterations);
    spriteobj.fy := Random(iterations);
    spriteobjlist.Add(spriteobj);
  end;
  chrono.Stop;
  Cout('Write END.');
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ TEST');
  chrono.Reset;
  chrono.Start;
  for x := 0 to iterations do
  begin
    spriteobjlist[x].Read;
  end;
  chrono.Stop;
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ END');
  Cout('Freeing Heap');
  spriteobjlist.Free;
  chrono.Free;
end;

procedure TestObjectList;
const
  iterations = 10000000;
var
  chrono : TChronometer;
  x : integer;
  objlist : TObjectList;
  spriteobj : TSpriteObj;
begin
  Randomize;
  Cout('Test TObjectList Container List of <TObject>');
  Cout(SizeOf(TSpriteObj).ToString + ' Bytes per Object');
  Cout('1000000 iterations');
  Cout('Write single thread');
  chrono := TChronometer.Create;
  chrono.Start;
  objlist := TObjectList.Create(True);
  for x := 0 to iterations do
  begin
    spriteobj := TSpriteObj.Create;
    spriteobj.fx := Random(iterations);
    spriteobj.fy := Random(iterations);
    objlist.Add(spriteobj);
  end;
  chrono.Stop;
  Cout('Write END.');
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ TEST');
  chrono.Reset;
  chrono.Start;
  for x := 0 to iterations do
  begin
    TSpriteObj(objlist[x]).Read;
  end;
  chrono.Stop;
  Cout('Time elapsed : ' + chrono.ElapsedMilliseconds.ToString + 'ms');
  Cout('READ END');
  Cout('Freeing Heap');
  objlist.Free;
  chrono.Free;
end;

procedure TSpriteObj.Read;
var
  instance : TSpriteObj;
begin
  instance := Self;
end;

{ TSpriteRec }

procedure TSpriteRec.Read;
var
  instance : TSpriteRec;
begin
  instance := Self;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    TestArrayofRecords;
    Cout('End test');
    Cout('********');
    TestArrayofRecordsPointers;
    Cout('********');
    Cout('End test');
    TestArrayofObjects;
    Cout('********');
    Cout('End test');
    TestObjectList;
    Cout('********');
    Cout('End test');
    TestGenericObjectList;
    Cout('********');
    Cout('End test');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
