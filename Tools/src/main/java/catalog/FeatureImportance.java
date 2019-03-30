package catalog;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FeatureImportance {
    private double rank;
    private String name;
    private double gain;
    private double cover;
    private double frequency;
}
