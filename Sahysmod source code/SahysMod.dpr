program SahysMod;

uses
  Forms,
  UBaseForm in 'UBaseForm.pas' {BaseForm},
  UMainForm in 'UMainForm.pas' {MainForm},
  UCloseForm in 'UCloseForm.pas' {CloseForm},
  UExtraUtils in 'UExtraUtils.pas',
  UDataMod in 'UDataMod.pas' {DataMod: TDataModule},
  UColumnsForm in 'UColumnsForm.pas' {ColumnsForm},
  UExampleForm in 'UExampleForm.pas' {ExampleForm},
  UNetworkForm in 'UNetworkForm.pas' {NetworkForm},
  USelectPolyForm in 'USelectPolyForm.pas' {SelectPolyForm},
  UInputData in 'UInputData.pas',
  USymbolsForm in 'USymbolsForm.pas' {SymbolsForm},
  UGuidedForm in 'UGuidedForm.pas' {GuidedForm},
  UMappingForm in 'UMappingForm.pas' {MappingForm},
  UWarningForm in 'UWarningForm.pas' {WarningForm},
  USelectExampleForm in 'USelectExampleForm.pas' {SelectExampleForm},
  UDataTest in 'UDataTest.pas',
  UInitialCalc in 'UInitialCalc.pas',
  UMainCalc in 'UMainCalc.pas',
  UNodalHelp in 'UNodalHelp.pas' {NodalHelpForm},
  USelectColumnForm in 'USelectColumnForm.pas' {SelectColumnForm},
  USelectClassesForm in 'USelectClassesForm.pas' {SelectClassesForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Spatial Agro-Hydro-Salinity model';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCloseForm, CloseForm);
  Application.CreateForm(TDataMod, DataMod);
  Application.CreateForm(TColumnsForm, ColumnsForm);
  Application.CreateForm(TExampleForm, ExampleForm);
  Application.CreateForm(TNetworkForm, NetworkForm);
  Application.CreateForm(TSelectPolyForm, SelectPolyForm);
  Application.CreateForm(TSymbolsForm, SymbolsForm);
  Application.CreateForm(TGuidedForm, GuidedForm);
  Application.CreateForm(TMappingForm, MappingForm);
  Application.CreateForm(TWarningForm, WarningForm);
  Application.CreateForm(TSelectExampleForm, SelectExampleForm);
  Application.CreateForm(TNodalHelpForm, NodalHelpForm);
  Application.CreateForm(TSelectColumnForm, SelectColumnForm);
  Application.CreateForm(TSelectClassesForm, SelectClassesForm);
  Application.Run;
end.
