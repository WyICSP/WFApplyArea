#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WFApplyAreaViewController.h"
#import "WFAreaDetailViewController.h"
#import "WFAreaOtherSetViewController.h"
#import "WFBilleMethodViewController.h"
#import "WFDiscountFeeViewController.h"
#import "WFDividIntoSetViewController.h"
#import "WFEditAreaAddressViewController.h"
#import "WFEditAreaDetailViewController.h"
#import "WFEditVipUserViewController.h"
#import "WFLookPowerFormViewController.h"
#import "WFManyTimeFeeViewController.h"
#import "WFMoreEquViewController.h"
#import "WFMyAreaViewController.h"
#import "WFSingleFeeViewController.h"
#import "WFApplyAreaDataTool.h"
#import "WFGatewayDataTool.h"
#import "WFApplyAreaOtherConfigModel.h"
#import "WFApplyAreaPublicAPI.h"
#import "WFAreaDetailModel.h"
#import "WFAreaFeeMsgData.h"
#import "WFBillMethodModel.h"
#import "WFDefaultChargeFeeModel.h"
#import "WFGatewayListModel.h"
#import "WFMyAreaListModel.h"
#import "WFPowerIntervalModel.h"
#import "WFRemoveEquModel.h"
#import "WFSavePhotoTool.h"
#import "WFUpgradeAreaData.h"
#import "WFUpgradeAreaModel.h"
#import "WFAddVipCountPickView.h"
#import "WFApplyAddressTableViewCell.h"
#import "WFApplyAreaFeeExplanView.h"
#import "WFApplyAreaFooterView.h"
#import "WFApplyAreaHeadView.h"
#import "WFApplyAreaItemTableViewCell.h"
#import "WFApplyAreaOtherTableViewCell.h"
#import "WFAreaDetailSinglePowerTableViewCell.h"
#import "WFBilleMethodCollectionReusableView.h"
#import "WFBilleMethodCollectionViewCell.h"
#import "WFBilleMethodMoneyTableViewCell.h"
#import "WFBilleMethodSectionView.h"
#import "WFBilleMethodTimeTableViewCell.h"
#import "WFDatePickView.h"
#import "WFDividIntoSetTableViewCell.h"
#import "WFDiviIntoSetEditTableViewCell.h"
#import "WFDiviIntoSetHeadTableViewCell.h"
#import "WFMyAreaListTableViewCell.h"
#import "WFMyAreaQRCodeView.h"
#import "WFSingleFeeUnifiedView.h"
#import "WFAreaDetailAddressTableViewCell.h"
#import "WFAreaDetailCollectFeeSectionView.h"
#import "WFAreaDetailDiscountTableViewCell.h"
#import "WFAreaDetailFooterView.h"
#import "WFAreaDetailManyTimesTableViewCell.h"
#import "WFAreaDetailOtherSectionView.h"
#import "WFAreaDetailOtherSetTableViewCell.h"
#import "WFAreaDetailPartnerTableViewCell.h"
#import "WFAreaDetailPersonTableViewCell.h"
#import "WFAreaDetailSingleTableViewCell.h"
#import "WFAreaDetailTimeTableViewCell.h"
#import "WFAreaVipUsersListTableViewCell.h"
#import "WFDiscountItemTableViewCell.h"
#import "WFMyAreaAddressTableViewCell.h"
#import "WFMyAreaChargePileView.h"
#import "WFMyAreaDetailHeadView.h"
#import "WFMyAreaPileListTableViewCell.h"
#import "WFNotHaveFeeTableViewCell.h"
#import "WFDiscountFeeAddView.h"
#import "WFDisUnifieldFeeTableViewCell.h"
#import "WFDisUnifieldSectionView.h"
#import "WFLookPowerFormHeadView.h"
#import "WFLookPowerFormListTableViewCell.h"
#import "WFLookProfitFormHeadView.h"
#import "WFMantTimesPowerTableViewCell.h"
#import "WFManyTimesFooterView.h"
#import "WFManyTimesUnifiedTableViewCell.h"
#import "WFProfitItemTableViewCell.h"
#import "WFSingleFeeTableViewCell.h"
#import "WFSinglePowerTableViewCell.h"
#import "WFCredBannerTableViewCell.h"
#import "WFCreditApplyNumTableViewCell.h"
#import "WFCreditPayTableViewCell.h"
#import "WFGatewayBottomView.h"
#import "WFGatewayListSectionView.h"
#import "WFGatewayListTableViewCell.h"
#import "WFGatewayListView.h"
#import "WFMoveEquHeadView.h"
#import "WFMoveEquItemTableViewCell.h"
#import "WFMoveEquSectionView.h"
#import "WFNRGatewayTableViewCell.h"
#import "WFNRReplaceGatewayListView.h"
#import "WFPileItemCollectionViewCell.h"
#import "WFCurrentWebViewController.h"
#import "WFJSApiTools.h"
#import "WFAbnormalPileViewController.h"
#import "WFCreditPayViewController.h"
#import "WFMyChargePileViewController.h"
#import "WFMyChargePileDataTool.h"
#import "WFCreditPayModel.h"
#import "WFMyChargePileModel.h"
#import "WFSearchBar.h"
#import "WFAbnomalListTableViewCell.h"
#import "WFAbnormalHeadView.h"
#import "WFChargePileSearchView.h"
#import "WFMyAreaSearchHeadView.h"
#import "WFMyChargePileHeadView.h"
#import "WFMyChargePileSectionView.h"
#import "WFMyChargePileTableViewCell.h"
#import "WFShopMallWebViewController.h"
#import "WFShareHelpTool.h"
#import "WFPersonCenterTableViewCell.h"
#import "WFPersonCenterViewController.h"
#import "WFPersonHeadView.h"
#import "WFUserCenterViewController.h"
#import "JMUpdataImage.h"
#import "WFUserCenterModel.h"
#import "WFUserCenterPublicAPI.h"
#import "YFMediatorManager+WFUser.h"

FOUNDATION_EXPORT double WFApplyAreaVersionNumber;
FOUNDATION_EXPORT const unsigned char WFApplyAreaVersionString[];

