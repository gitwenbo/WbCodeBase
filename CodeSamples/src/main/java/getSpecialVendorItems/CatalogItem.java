package getSpecialVendorItems;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * User: rod
 * Date: 10/14/15
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
@EqualsAndHashCode(of = { "itemId" })
@SuppressWarnings("PMD.UnusedPrivateField")
public class CatalogItem {
	private Long itemId;
	private String itemName;
	private String originalItemName;
	private Long productId;
	private String productName;
	private String brandName;
	private String manufacturer;
	private String barcode;
	private String modelName;
	private List<String> customModelName;
	private List<Map<String, String>> attributes = Lists.newArrayList();
	private List<Map<String, String>> tags = Lists.newArrayList();
	private Long categoryId;
	private String productCleansing;
	private Double averageSalePrice;
	private Integer vendorItemCount;
	private String itemImageUrl;
	private List<Long> displayCategoryCodes;
	private List<String> vendorIds;
	private List<String> externalVendorSkuCodes;

	private String pHashString;
	@JsonIgnore
	private boolean allowCalcPHash = false;

	private Boolean isParallelImported; //병행수입
	private Boolean isOverseasPurchased; //해외구매대행
	private Boolean abnormalUsedFlag = false;
	private String offerCondition; // 신규,중고 정보
	private String mainImageMd5;
	private Boolean valid;
	private Date createdAt;
	private Boolean mergeFlag;
	private List<Map<String, String>> exposeAttributes = Lists.newArrayList();

	protected CatalogItem(CatalogItem catalogItem) {
		this(
			catalogItem.getItemId()
			, catalogItem.getItemName()
			, catalogItem.getOriginalItemName()
			, catalogItem.getProductId()
			, catalogItem.getProductName()
			, catalogItem.getBrandName()
			, catalogItem.getManufacturer()
			, catalogItem.getBarcode()
			, catalogItem.getModelName()
			, catalogItem.getCustomModelName()
			, catalogItem.getAttributes()
			, catalogItem.getTags()
			, catalogItem.getCategoryId()
			, catalogItem.getProductCleansing()
			, catalogItem.getAverageSalePrice()
			, catalogItem.getVendorItemCount()
			, catalogItem.getItemImageUrl()
			, catalogItem.getDisplayCategoryCodes()
			, catalogItem.getVendorIds()
			, catalogItem.getExternalVendorSkuCodes()
			, catalogItem.getPHashString()
			, catalogItem.isAllowCalcPHash()
			, catalogItem.getIsParallelImported()
			, catalogItem.getIsOverseasPurchased()
			, catalogItem.getAbnormalUsedFlag()
			, catalogItem.getOfferCondition()
			, catalogItem.getMainImageMd5()
			, catalogItem.getValid()
			, catalogItem.getCreatedAt()
			, catalogItem.getMergeFlag()
			, catalogItem.getExposeAttributes()
		);
	}

	public void addAttribute(String key, String value) {
		attributes.add(createKeyValueMap(key, value));
	}

	public void addExposeAttribute(String key, String value) {
		exposeAttributes.add(createKeyValueMap(key, value));
	}

	private Map<String, String> createKeyValueMap(String key, String value) {
		Map<String, String> attributeMap = Maps.newHashMap();
		attributeMap.put(AttributeMapKey.key.name(), key);
		attributeMap.put(AttributeMapKey.value.name(), value);
		return attributeMap;
	}

	public void addTags(Map<String, Set<String>> tagValues) {
		for (Map.Entry<String, Set<String>> tagValuesEntry : tagValues.entrySet()) {
			for (String value : tagValuesEntry.getValue()) {
				addTag(tagValuesEntry.getKey(), value);
			}
		}
	}

	public void addTag(String key, String value) {
		tags.add(createKeyValueMap(key, value));
	}

	public enum AttributeMapKey {
		key, value
	}

	public CatalogItem shallowCopy() {
		return new CatalogItem(this);
	}



}
